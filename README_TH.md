# XjRibbon

🇹🇭 [ภาษาไทย] | 🇺🇸 [English](README.md)

[screenshot](full ribbon with all 7 control types visible — Home tab showing Large/Small/Toggle buttons, View tab showing SplitButton + CheckBox items + Separator)

> ชุด ribbon toolbar สไตล์ MS Office สำหรับ Xojo Desktop และ Web

## คุณสมบัติ

- Control ทั้ง 7 ประเภท: ปุ่มขนาดใหญ่, ปุ่มขนาดเล็ก, ปุ่มสลับสถานะ, Dropdown, SplitButton, CheckBox, ตัวคั่น
- Desktop (DesktopCanvas) และ Web (WebCanvas) — API เหมือนกันทุกประการ
- โหมดมืด, HiDPI, การนำทางด้วยคีย์บอร์ด (KeyTips) บน Desktop
- โปรแกรมออกแบบแบบภาพพร้อมตัวสร้างโค้ด

## ความต้องการของระบบ

- Xojo 2024r3 หรือใหม่กว่า
- macOS, Windows, หรือ Linux (Desktop); เว็บเบราว์เซอร์ใดก็ได้ (Web)

## เริ่มต้นใช้งาน (Desktop)

[screenshot](ribbon running in the demo app — Home tab active)

```xojo
// 1. Add XjRibbon canvas to your window (Height = 122)
// 2. In Opening event:

Var homeTab As XjRibbonTab = XjRibbon1.AddTab("Home")
homeTab.KeyTip = "H"

Var clipGroup As XjRibbonGroup = homeTab.AddNewGroup("Clipboard")
Call clipGroup.AddLargeButton("Paste", "clipboard.paste")
Call clipGroup.AddSmallButton("Cut", "clipboard.cut")
Call clipGroup.AddSmallButton("Copy", "clipboard.copy")
```

จัดการอีเวนต์ใน XjRibbon1:
```xojo
Sub ItemPressed(tag As String)
  MessageBox "Pressed: " + tag
End Sub

Sub DropdownMenuAction(itemTag As String, menuItemTag As String)
  MessageBox itemTag + " → " + menuItemTag
End Sub
```

## เริ่มต้นใช้งาน (Web)

[screenshot](web ribbon in browser — same layout as desktop)

API เหมือนกัน — เพิ่ม XjRibbon ลงใน WebPage แทนที่จะเป็น DesktopWindow

## ประเภทของ Control

[screenshot](all 7 control types labeled — View tab with SplitButton, CheckBox rows, Separator gap visible)

| ประเภท | เมธอด | คำอธิบาย |
|--------|--------|-----------|
| ปุ่มขนาดใหญ่ | `group.AddLargeButton(caption, tag)` | ไอคอน 32px + ข้อความด้านล่าง, ความสูงเต็มกลุ่ม |
| ปุ่มขนาดเล็ก | `group.AddSmallButton(caption, tag)` | ไอคอน 16px + ข้อความด้านขวา, เรียงซ้อน 3 ปุ่มต่อคอลัมน์ |
| ปุ่มสลับสถานะ | `group.AddLargeButton(caption, tag)` + `.IsToggle = True` | สถานะกดหรือเปิดใช้งาน |
| ปุ่ม Dropdown | `group.AddDropdownButton(caption, tag)` + `.AddMenuItem(...)` | เปิดเมนูป๊อปอัป |
| ปุ่ม SplitButton | `group.AddSplitButton(caption, tag)` + `.AddMenuItem(...)` | ส่วนหลักจะเรียก ItemPressed โดยตรง ส่วนลูกศรเปิดเมนู |
| CheckBox | `group.AddCheckBox(caption, tag, initialChecked)` | สัญลักษณ์ ☐/☑ พร้อมข้อความ |
| ตัวคั่น | `group.AddSeparator()` | ช่องว่างระหว่างกลุ่ม control |

## เอกสาร API

### XjRibbon (Canvas)

#### แท็บ
```xojo
Function AddTab(caption As String) As XjRibbonTab
Function AddContextualTab(caption As String, contextGroup As String, accentColor As Color) As XjRibbonTab
Sub ShowContextualTabs(contextGroup As String)
Sub HideContextualTabs(contextGroup As String)
Sub SelectTab(index As Integer)
```

#### รายการ
```xojo
Function GetToggleState(tag As String) As Boolean
Sub SetToggleState(tag As String, value As Boolean)
Sub SetCollapsed(value As Boolean)
Function IsCollapsed() As Boolean
Sub Clear()
```

#### อีเวนต์
```xojo
Event ItemPressed(tag As String)
Event DropdownMenuAction(itemTag As String, menuItemTag As String)
Event CollapseStateChanged(isCollapsed As Boolean)
```

#### ค่าคงที่
```xojo
kXjRibbonVersion As String  // "1.0.0"
```

### XjRibbonTab
```xojo
Function AddNewGroup(caption As String) As XjRibbonGroup
Property KeyTip As String
```

### XjRibbonGroup
```xojo
Function AddLargeButton(caption As String, tag As String) As XjRibbonItem
Function AddLargeButton(caption As String, tag As String, icon As Picture) As XjRibbonItem
Function AddSmallButton(caption As String, tag As String) As XjRibbonItem
Function AddDropdownButton(caption As String, tag As String) As XjRibbonItem
Function AddSplitButton(caption As String, tag As String) As XjRibbonItem
Function AddCheckBox(caption As String, tag As String, initialChecked As Boolean = False) As XjRibbonItem
Sub AddSeparator()
```

### XjRibbonItem
```xojo
Property Icon As Picture
Property TooltipText As String
Property IsEnabled As Boolean
Property IsToggle As Boolean
Property IsToggleActive As Boolean
Property IsSplitButton As Boolean
Property KeyTip As String
Sub AddMenuItem(caption As String, tag As String)
```

## หัวข้อขั้นสูง

### ข้อความปุ่มหลายบรรทัด
ใช้ Chr(10) เพื่อแบ่งข้อความออกเป็นสองบรรทัด:
```xojo
Var navPane As XjRibbonItem = group.AddSplitButton("Navigation" + Chr(10) + "pane", "nav")
```

### ไอคอน
```xojo
Var btn As XjRibbonItem = group.AddLargeButton("Save", "file.save")
btn.Icon = SaveIcon  // 32×32 Picture
```

### แท็บตามบริบท
[screenshot](contextual tab with accent color visible — Table Tools style)
```xojo
Var tableTab As XjRibbonTab = XjRibbon1.AddContextualTab("Table Tools", "table", Color.RGB(68, 114, 196))
// Show when table is selected:
XjRibbon1.ShowContextualTabs("table")
```

### KeyTips (สำหรับ Desktop เท่านั้น)
```xojo
homeTab.KeyTip = "H"
pasteItem.KeyTip = "V"
// Press Alt to reveal badges; type key to activate
```

### โหมดมืด
XjRibbon ตรวจจับโหมดมืดของระบบโดยอัตโนมัติ ไม่ต้องเขียนโค้ดเพิ่มเติม

## หมายเหตุสำหรับ Web

ไลบรารี Web ใช้ API เดียวกันแต่มีข้อจำกัดดังนี้:
- ไม่รองรับการนำทางด้วยคีย์บอร์ด KeyTip (Web ใช้เมาส์เป็นหลัก)
- Hover ทำงานผ่าน JS mousemove injection (อัตโนมัติ ไม่ต้องตั้งค่า)
- ปรับขนาด 120% ในเลย์เอาต์ของคุณ (ความสูง Canvas = 146 แทนที่จะเป็น 122)

## โปรแกรมออกแบบ

[screenshot](XjRibbon Designer v2.0.0 — showing tree structure with all 7 control types, inspector panel, and Copy Code button)

**XjRibbon Designer v2.0.0** — โปรแกรมออกแบบริบบอนแบบภาพพร้อมตัวสร้างโค้ด

รองรับ control ทั้ง 7 ประเภท สร้างริบบอนด้วยภาพ จากนั้นคลิก **Copy Code** เพื่อวางโค้ด Xojo ลงในอีเวนต์ Opening/Shown ของโปรเจกต์ได้ทันที

- บันทึก/โหลดไฟล์โปรเจกต์ `.ribbon`
- รองรับโหมดมืด
- สร้างโค้ด Xojo พร้อมใช้งานสำหรับ Desktop หรือ Web

## สัญญาอนุญาต
MIT — ดูที่ [LICENSE](LICENSE)
