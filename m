Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Wed, 1 Feb 2017 10:15:34 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170201091534.GA25025@gmail.com>
References: <20170126165940.30799-1-thgarnie@google.com>
 <20170126165940.30799-3-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170126165940.30799-3-thgarnie@google.com>
Subject: [kernel-hardening] Re: [PATCH v2 3/3] x86: Make the GDT remapping read-only on 64 bit
To: Thomas Garnier <thgarnie@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@amacapital.net>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Rusty Russell <rusty@rustcorp.com.au>, Christian Borntraeger <borntraeger@de.ibm.com>, Fenghua Yu <fenghua.yu@intel.com>, He Chen <he.chen@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Adam Buchbinder <adam.buchbinder@gmail.com>, Stanislaw Gruszka <sgruszka@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, Chen Yucong <slaoub@gmail.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, David Vrabel <david.vrabel@citrix.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Prarit Bhargava <prarit@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-pm@vger.kernel.org, linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, lguest@lists.ozlabs.org, kvm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


* Thomas Garnier <thgarnie@google.com> wrote:

> This patch makes the GDT remapped pages read-only to prevent corruption.
> This change is done only on 64 bit.

Please spell '64-bit' consistently through the series. I've seen two variants:

  64 bit
  64bit

> +/*
> + * The LTR instruction marks the TSS GDT entry as busy. In 64bit, the GDT is
> + * a read-only remapping. To prevent a page fault, the GDT is switched to the
> + * original writeable version when needed.

s/In 64bit,
 /On 64-bit kernels,

> + */
> +#ifdef CONFIG_X86_64
> +static inline void native_load_tr_desc(void)
> +{
> +	struct desc_ptr gdt;
> +	int cpu = raw_smp_processor_id();
> +	bool restore = false;
> +	struct desc_struct *fixmap_gdt;
> +
> +	native_store_gdt(&gdt);
> +	fixmap_gdt = get_cpu_fixmap_gdt(cpu);
> +
> +	/*
> +	 * If the current GDT is the read-only fixmap, swap to the original
> +	 * writeable version. Swap back at the end.
> +	 */
> +	if (gdt.address == (unsigned long)fixmap_gdt) {
> +		load_direct_gdt(cpu);
> +		restore = true;
> +	}
> +	asm volatile("ltr %w0"::"q" (GDT_ENTRY_TSS*8));
> +	if (restore)
> +		load_fixmap_gdt(cpu);

Please use bool plus 0/1, it's more readable (to me) than the true/false notation.

>  extern void switch_to_new_gdt(int);
> +extern void load_direct_gdt(int);
>  extern void load_fixmap_gdt(int);

> +/* Load the original GDT from the per-cpu structure */
> +void load_direct_gdt(int cpu)
> +{
> +	struct desc_ptr gdt_descr;
> +
> +	gdt_descr.address = (long)get_cpu_direct_gdt(cpu);

Please name the functions in an easier to understand way, such as:

	get_cpu_gdt_rw()
	get_cpu_gdt_ro()

that the GDT is in the direct mappings is less important than the fact the the 
address is writable ...

> +}
> +EXPORT_SYMBOL(load_direct_gdt);

EXPORT_SYMBOL_GPL(), or no export at all.

> +EXPORT_SYMBOL(load_fixmap_gdt);

ditto.

>  	 * VT restores TR but not its size.  Useless.
>  	 */
> -	struct desc_ptr *gdt = this_cpu_ptr(&host_gdt);
>  	struct desc_struct *descs;
>  
> -	descs = (void *)gdt->address;
> +	descs = (void *)get_current_direct_gdt();

Couldn't the type cast be dropped?

>  
> -	table_base = gdt->address;
> +	table_base = (unsigned long)get_current_direct_gdt();

Instead of spreading these type casts far and wide please introduce another 
accessor the returns 'unsigned long':

	get_cpu_gdt_rw_vaddr()

or such.

Thanks,

	Ingo
