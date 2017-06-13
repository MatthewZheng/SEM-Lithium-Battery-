rollout spl "Simple Generator Splines v1.1" width:230 height:282
(
	global pickobj=undefined
	global ii
	spinner randxmax "" pos:[136,24] width:56 height:16 range:[-100000,100000,100]
	spinner randxmin "" pos:[72,24] width:56 height:16 range:[-100000,10000,-100]
	label lbl1 "Random_X:" pos:[12,24] width:56 height:16
	label lbl2 "      Min.              Max." pos:[72,8] width:120 height:16
	spinner randymax "" pos:[136,48] width:56 height:16 range:[-100000,10000,100]
	spinner randymin "" pos:[72,48] width:56 height:16 range:[-100000,10000,-100]
	label lbl3 "Random_Y:" pos:[12,48] width:56 height:16
	spinner randzmax "" pos:[136,72] width:56 height:16 range:[-100000,10000,100]
	spinner randzmin "" pos:[72,72] width:56 height:16 range:[-100000,10000,-100]
	label lbl4 "Random_Z:" pos:[12,72] width:60 height:16
	spinner spn7 "Count:" pos:[146,96] width:76 height:16 range:[0,10000,50] type:#integer
	spinner spn8 "Step:" pos:[150,144] width:72 height:16 range:[0,10000,1] scale:0.001
	spinner spn9 "Length:" pos:[143,120] width:79 height:16 range:[0,10000,200] 
	spinner spn10 "Threshold:" pos:[136,168] width:86 height:16 range:[0,10000,0]
	checkbox chk1 "Use Shape" pos:[8,96] width:80
	checkbox chk2 "Upd. in real time" pos:[8,168] tooltip:"WARNING: Speed of the script can be reduced more than twice"
	pickbutton pbn "Pick Shape" pos:[8,116] width:80
	spinner spn11 "Spacing:" pos:[28,144] width:70 enabled:false range:[0.0001,1,0.1] scale:0.001
	button btn1 "Generate" pos:[16,194] width:128 height:40
	button btn2 "Clear" pos:[146,194] width:68 height:40
	label lbl "Simple Generator Splines v1.1"
	hyperlink hp "by Bodyul Vladislav" address:"http://bodulwlpc.wix.com/ms-scripts" color:(color 0 160 250) visitedcolor:(color 0 160 250) hovercolor:(color 250 0 0) align:#center
	
	on chk1 changed state do (
		if state==true then (spn11.enabled=true;spn7.enabled=false) else (spn11.enabled=false;spn7.enabled=true)
		)
	
	on pbn picked obj do (
	try (for o in $gen_shape* do o.name="old_gen_shape")catch()
		
	if (superclassof obj)==shape then (
		pickobj=obj
		pbn.caption=obj.name
		) else pickobj=undefined
		)
	
	on btn1 pressed do (
		print chk1.state==true
		arrp=#()
		arrsp=#()
		arradsp=#()
		ii=1
		if chk1.state==true and (isvalidnode pickobj==true) then (
		for i=0.0 to 1.0 by spn11.value do (
			r=[(random randxmin.value randxmax.value),(random randymin.value randymax.value),(random randzmin.value randzmax.value)]
			append arrp ((lengthinterp pickobj i)+r)
			append arrsp (splineshape pos:((lengthinterp pickobj i)+r) wirecolor:white name:("gen_shape"+(ii as string)))
			append arradsp (addnewspline arrsp[ii])
			ii+=1
				)) else (
		for i=1 to spn7.value do (
			r=[(random randxmin.value randxmax.value),(random randymin.value randymax.value),(random randzmin.value randzmax.value)]
			append arrp r 
			append arrsp (splineshape pos:r wirecolor:white name:("gen_shape"+(ii as string)))
			append arradsp (addnewspline arrsp[i])
				))
		for i=1 to spn9.value do (
		if keyboard.escpressed==true then (return())
			for p=1 to arrp.count do (
				if p<=(arrp.count-1) then (
					arrp[p]+=((normalize(arrp[p+1]-arrp[p]))*spn8.value)
					if i>=spn10.value then (
					addknot arrsp[p] 1 #smooth #curve arrp[p])) else (
						arrp[p]+=((normalize(arrp[1]-arrp[p]))*spn8.value)
						addknot arrsp[p] 1 #smooth #curve arrp[p])
						try (updateshape arrsp[p]) catch()
			)
		if chk2.state==true then (
		redrawviews()
		)
		)
		
		
		for i=1 to arrsp.count do (
		try(
		deleteknot arrsp[i] 1 1
		deleteknot arrsp[i] 1 1	
			)catch()
		try(updateshape arrsp[i])catch()
			)
			
		if chk1.state==true and (isvalidnode pickobj==true) then (
			for i=1 to arrsp.count do (
				try(
					deleteknot arrsp[i] 1 1
					deleteknot arrsp[i] 1 1	
					)catch()
				try(updateshape arrsp[i])catch()
					)
			)
			
		max views redraw 
		delete arrsp[arrsp.count]
	)
	
	on btn2 pressed do (
		try (delete $gen_shape*)catch()
		)
)
CreateDialog spl