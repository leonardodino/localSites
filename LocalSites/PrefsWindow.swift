//
//  PrefsWindow.swift
//  LocalSites
//
//  Created by Lukas Zeller on 13.10.17.
//  Copyright © 2017 plan44.ch. All rights reserved.
//

import Cocoa

protocol PrefsWindowDelegate {
  func prefsDidUpdate()
}

class PrefsWindow: NSWindowController, NSWindowDelegate, NSTableViewDataSource {

  @IBOutlet weak var monochromeIconCheckbox: NSButton!
  @IBOutlet weak var browseDomainsTable: NSTableView!
    
  var browseDomains = [ "wittyname.net.", "dns-sd.org."]
  var delegate: PrefsWindowDelegate?

  override var windowNibName : NSNib.Name! {
    return NSNib.Name(rawValue: "PrefsWindow")
  }

  override func windowDidLoad() {
    super.windowDidLoad()

    self.window?.center()
    self.window?.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)

    
    let defaults = UserDefaults.standard
    let monochrome = defaults.bool(forKey: "monochromeIcon")
    monochromeIconCheckbox.state = monochrome ? NSControl.StateValue.on : NSControl.StateValue.off
    
    if let domainList = defaults.array(forKey: "browseDomains") as? [String] {
        browseDomains = domainList
    }
    browseDomainsTable.dataSource = self
  }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return browseDomains.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "domainCell"), owner: nil) as! NSTextFieldCell
        view.stringValue = browseDomains[row]
        return view
    }
    
  func windowWillClose(_ notification: Notification) {
    let defaults = UserDefaults.standard
    defaults.setValue(monochromeIconCheckbox.state==NSControl.StateValue.on, forKey: "monochromeIcon")
    defaults.setValue(browseDomains, forKey: "browseDomains")
    delegate?.prefsDidUpdate()
  }

}
