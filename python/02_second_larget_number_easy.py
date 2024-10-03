def second_largest(list):
    list.sort()
    return list[-2]

li=[]
n=int(input("enter size of list: "))
for i in range(0,n):
    e=int(input("enter the list elements: "))
    li.append(e)

print("second larget number is")
print(second_largest(li))