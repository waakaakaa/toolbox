# coding=utf-8
import Tkinter,time,visa,string,tkMessageBox
debug = 0

if debug==0:
	rm = visa.ResourceManager()
	res = rm.open_resource('GPIB0::11::INSTR')
	res.write(':SLOT 1')

top = Tkinter.Tk()
top.geometry('500x200')

def turnOnOff(state):
	if state=='On':
		if debug==0:
			res.write(':LASER ON')
	else:
		if debug==0:
			res.write(':LASER OFF')

def tuneCurrent(port,current):
	try:
		fcurrent = string.atof(current)
	except Exception,ex:
		tkMessageBox.showinfo('wrong','Invalid input!!!')
		return
	fcurrent = fcurrent/1000
	if (fcurrent>0.15 or fcurrent<0):
		tkMessageBox.showinfo('wrong','Current out of range!!!')
		return
	print(port,fcurrent)
	if debug==0:
		res.write(':PORT ' + bytes(port))
		res.write(':ILD:SET ' + bytes(fcurrent))

def scanCurrent(port):
	print('start scanning at',port)
	if debug==0:
		res.write(':PORT ' + bytes(port))
	i = 0.001
	while i<=0.040:
		print(i)
		if port==6:
			e6.delete(0,Tkinter.END)
			e6.insert(0,i*1000)
		elif port==7:
			tv7.set(i*1000)
		else:
			tv8.set(i*1000)
		if debug==0:
			res.write(':ILD:SET ' + bytes(i))
		time.sleep(0.5)
		i += 0.001

def readCurrent(port):
	if debug==0:
		res.write(':PORT ' + bytes(port))
		return string.atof(res.query(':ILD:SET?').split(' ')[1])*1000

i6 = readCurrent(6)
i7 = readCurrent(7)
i8 = readCurrent(8)

button_on = Tkinter.Button(top,text='ON',command=lambda:turnOnOff('On'))
button_on.grid(row=0,column=1)

button_off = Tkinter.Button(top,text='OFF',command=lambda:turnOnOff('Off'))
button_off.grid(row=0,column=2)

l6 = Tkinter.Label(top,text='PORT 6:')
l6.grid(row=1,column=0)
tv6 = Tkinter.StringVar()
e6 = Tkinter.Entry(top,textvariable=tv6)
tv6.set(i6)
e6.grid(row=1,column=1)
b6 = Tkinter.Button(top,text='SET 6',command=lambda:tuneCurrent(6,e6.get()))
b6.grid(row=1,column=2)
s6 = Tkinter.Button(top,text='SCAN',command=lambda:scanCurrent(6))
s6.grid(row=1,column=3)

l7 = Tkinter.Label(top,text='PORT 7:')
l7.grid(row=2,column=0)
tv7 = Tkinter.StringVar()                                                                     
e7 = Tkinter.Entry(top,textvariable=tv7)                                                      
tv7.set(i7)
e7.grid(row=2,column=1)
b7 = Tkinter.Button(top,text='SET 7',command=lambda:tuneCurrent(7,e7.get()))
b7.grid(row=2,column=2)
s7 = Tkinter.Button(top,text='SCAN',command=lambda:scanCurrent(7))
s7.grid(row=2,column=3)

l8 = Tkinter.Label(top,text='PORT 8:')
l8.grid(row=3,column=0)
tv8 = Tkinter.StringVar()                                                                     
e8 = Tkinter.Entry(top,textvariable=tv8)                                                      
tv8.set(i8)
e8.grid(row=3,column=1)
b8 = Tkinter.Button(top,text='SET 8',command=lambda:tuneCurrent(8,e8.get()))
b8.grid(row=3,column=2)
s8 = Tkinter.Button(top,text='SCAN',command=lambda:scanCurrent(8))
s8.grid(row=3,column=3)

Tkinter.mainloop()
