boolean zip(a, b) {
    def root = node.map.root
    boolean changed = false

    int ix = 0
    // maybe sort by alphabet
    def ach = a.children
    def bch = b.children
    int asz = ach.size()
    int bsz = bch.size()
    root['asz'] = asz
    root['bsz'] = bsz
    while (true) {
        if ((asz <= ix) && (bsz <= ix)) break
        // side A will get the missing ones
        if (bsz <= ix) {
            // this was deleted on b, mark it red
            ach[ix].style.backgroundColorCode = '#fe4243'
            changed = true
        } else if (asz <= ix) {
            // b has something a don't
            def added = a.appendAsCloneWithSubtree(bch[ix])
            added.style.backgroundColorCode = '#42ff42'
            changed = true
        } else if (ach[ix].text == bch[ix].text) {
            ach[ix].style.backgroundColorCode = '#ffffff'

            boolean nestedChanged = zip(ach[ix], bch[ix])
            changed = changed || nestedChanged
        } else {
            // change
            ach[ix].style.backgroundColorCode = '#8080ff'
            changed = true
        }

        ix += 1
    }
    if (changed) a.style.textColorCode = '#00cc00'
    else a.style.textColorCode = '#000000'
    return changed
}

void main(node) {
    def root = node.map.root
    try {
        def sideA = root.find { it.text == "sideA" }[0]
        def sideB = root.find { it.text == "sideB" }[0]

        zip(sideA, sideB)

    } catch (Exception ex) {
        root['err'] = ex.toString()
        ByteArrayOutputStream baos = new ByteArrayOutputStream(1024)
        PrintWriter writer = new PrintWriter(baos)
        ex.printStackTrace(writer)
        writer.close()
        root.setDetails(new String(baos.toByteArray()))

    }
}

main(node)