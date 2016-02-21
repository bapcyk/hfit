wm title . Fitting

proc mkpt {canv x y {c red}} {
    set r 3
    set p0x [expr $x-$r]; set p0y [expr $y-$r]
    set p1x [expr $x+$r]; set p1y [expr $y+$r]
    $canv create oval $p0x $p0y $p1x $p1y -fill $c -width 1 -tags pt
}

proc cls {} {
    .top.left.canv delete all
}

proc bbox2xy {x0 y0 x1 y1} {
    set x [expr int($x0+($x1-$x0)/2)]
    set y [expr int($y0+($y1-$y0)/2)]
    return "$x $y"
}

proc sendCalc {} {
    set coords {}
    foreach item [.top.left.canv find withtag pt] {
      lappend coords [bbox2xy {*}[.top.left.canv coords $item]]
    }
    puts "calc [regsub -all {[{}]} $coords {}]"
}


proc takeCalc {x0 y0 x1 y1} {
    .top.left.canv create line $x0 $y0 $x1 $y1
}


proc buildUI {} {
  frame .top -borderwidth 5
  pack .top -side top -fill x

  frame .top.left -borderwidth 5
  pack .top.left -side left -fill both

  canvas .top.left.canv -background white
  bind .top.left.canv <ButtonPress-1> {mkpt %W %x %y}
  pack .top.left.canv -side left -fill both

  frame .top.right
  pack .top.right -side right -fill y

  button .top.right.cls -text Clear -command cls
  button .top.right.calc -text Calculate -command sendCalc
  button .top.right.q -text Quit -command exit
  pack .top.right.q .top.right.calc .top.right.cls -side bottom -fill x
}

buildUI
