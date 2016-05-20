from itertools import groupby
from operator import itemgetter
a = {'src': '89089117966', 'dst': '89089117966', }
b = {'src': '89079117966', 'dst': '8909as9117966', }
c = {'src': '89089117966', 'dst':'89079117966', }
#src [0]
#dst [1]
voip_logs = list()
for i in a, b, c:
    voip_logs.append(i)
result_groups = []
result_subgroup = {}
voip_logs = list(voip_logs)
voip_logs = sorted(voip_logs, key=itemgetter('src'))
for key, group in groupby(voip_logs, lambda x: x['src']):
    #for key2, sub_group in groupby(group, lambda x: x['dst']):
    #    key2['full_bill'] = sub_group['']
    print(key)
    for i in group:
        print(i)
    print "\n"
