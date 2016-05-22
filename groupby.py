from itertools import groupby
from operator import itemgetter
from pprint import pprint
a = {'src': '89089117966', 'dst': '8111111111', 'sum': 500 }
b = {'src': '89079117966', 'dst': '822222222', 'sum': 300 }
c = {'src': '89089117966', 'dst':'8333333333', 'sum': 100 }
d = {'src': '89089117966', 'dst': '8111111111', 'sum': 66 }
#src [0]
#dst [1]
voip_logs = list()
for i in a, b, c, d:
    voip_logs.append(i)
result_groups = []
result_subgroup = {}
voip_logs = sorted(voip_logs, key=itemgetter('src'))
for key, group in groupby(voip_logs, key=itemgetter('src')):
    print("KEY1 " + key)
    grouper = {'dst': key}
    result_groups.append(grouper)
    sub_grp = sorted(group, key=itemgetter('dst'))
    for key2, sub_group in groupby(sub_grp, lambda x: x['dst']):
        print("KEY2 " + key2)
        result_sum = 0
        sub_group = list(sub_group)
        for i in sub_group:
            print(i)
            result_sum += i['sum']
        sub_group[0]['sum'] = result_sum
        result_groups.append(sub_group[0])
    for i in group:
        print(i)
    print("END OF KEY1\n")

pprint(result_groups)
