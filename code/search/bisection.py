def bisection(what, sorted_list, debug=False):
    if len(sorted_list) == 0:
        return 'Not found.'
    middle_index = int(len(sorted_list) / 2)
    if debug:
        print('Comparing {} with {}.'.format(what, sorted_list[middle_index]))
    if what == sorted_list[middle_index]:
        return sorted_list[middle_index]
    if what < sorted_list[middle_index]:
        return bisection(what, sorted_list[:middle_index], debug)
    else:
        return bisection(what, sorted_list[middle_index+1:], debug)
