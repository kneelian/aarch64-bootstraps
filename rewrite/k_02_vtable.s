.balign 0x800
_VECTOR_TABLE_EL1:
	_curr_el_sp0_sync_1:
	//udf 1
	b el0_entry
	.balign 0x80

	_curr_el_sp0_irq_1:
	//udf 2
	b el0_entry
	.balign 0x80

	_curr_el_sp0_fiq_1:
	//udf 3
	b el0_entry
	.balign 0x80 
	
	_curr_el_sp0_serror_1:
	//udf 4
	b el0_entry
	.balign 0x80 

	_curr_el_spx_sync_1:
	//udf 5
	b el0_entry
	.balign 0x80
	
	_curr_el_spx_irq_1:
	//udf 6
	b el0_entry
	.balign 0x80 
	
	_curr_el_spx_fiq_1:
	//udf 7
	b el0_entry
	.balign 0x80 
	
	_curr_el_spx_serror_1:
	//udf 8
	b el0_entry
	.balign 0x80 

	_lower_el_aarch64_sync_1:
	//udf 9
	b el0_entry
	.balign 0x80

	_lower_el_aarch64_irq_1:
	//udf 10
	b el0_entry
	.balign 0x80 

	_lower_el_aarch64_fiq_1:
	//udf 11
	b el0_entry
	.balign 0x80 

	_lower_el_aarch64_serror_1:
	//udf 12
	b el0_entry
	.balign 0x80 

	_lower_el_aarch32_sync_1:
	.balign 0x80
	_lower_el_aarch32_irq_1:
	.balign 0x80 
	_lower_el_aarch32_fiq_1:
	.balign 0x80 
	_lower_el_aarch32_serror_1:
	.balign 0x80 

.balign 0x800
_VECTOR_TABLE_EL0:
	_curr_el_sp0_sync_0:
	.balign 0x80
	_curr_el_sp0_irq_0:
	.balign 0x80 
	_curr_el_sp0_fiq_0:
	.balign 0x80 
	_curr_el_sp0_serror_0:
	.balign 0x80 

	_curr_el_spx_sync_0:
	.balign 0x80
	_curr_el_spx_irq_0:
	.balign 0x80 
	_curr_el_spx_fiq_0:
	.balign 0x80 
	_curr_el_spx_serror_0:
	.balign 0x80 

	_lower_el_aarch64_sync_0:
	.balign 0x80
	_lower_el_aarch64_irq_0:
	.balign 0x80 
	_lower_el_aarch64_fiq_0:
	.balign 0x80 
	_lower_el_aarch64_serror_0:
	.balign 0x80 

	_lower_el_aarch32_sync_0:
	.balign 0x80
	_lower_el_aarch32_irq_0:
	.balign 0x80 
	_lower_el_aarch32_fiq_0:
	.balign 0x80 
	_lower_el_aarch32_serror_0:
	.balign 0x80 
