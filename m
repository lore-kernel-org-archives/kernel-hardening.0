Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 15 Apr 2016 09:47:26 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160415074726.GC30715@gmail.com>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
 <1460672954-32567-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1460672954-32567-3-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v5 02/21] x86, KASLR: Handle kernel relocation above 2G
To: Kees Cook <keescook@chromium.org>
Cc: Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> From: Baoquan He <bhe@redhat.com>
> 
> When processing the relocation table, the offset used to calculate the
> relocation is an int. This is sufficient for calculating the physical
> address of the relocs entry on 32-bit systems and on 64-bit systems when
> the relocation is under 2G. To handle relocations above 2G (seen in
> situations like kexec, netboot, etc), this offset needs to be calculated
> using a long to avoid wrapping and miscalculating the relocation.
> 
> Signed-off-by: Baoquan He <bhe@redhat.com>
> [kees: rewrote changelog]
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/boot/compressed/misc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
> index f35ad9eb1bf1..c4477d5f3fff 100644
> --- a/arch/x86/boot/compressed/misc.c
> +++ b/arch/x86/boot/compressed/misc.c
> @@ -295,7 +295,7 @@ static void handle_relocations(void *output, unsigned long output_len)
>  	 * So we work backwards from the end of the decompressed image.
>  	 */
>  	for (reloc = output + output_len - sizeof(*reloc); *reloc; reloc--) {
> -		int extended = *reloc;
> +		long extended = *reloc;
>  		extended += map;
>  
>  		ptr = (unsigned long)extended;

This patch and the code it patches is just plain sloppy. See this cast? This is an 
object lesson of why type casts in C are actively dangerous, they have hidden the 
32-bit truncation bug you've fixed with this patch.

But the primary bug, the cast, should be fixed! Together with all the other casts 
of 'extended'.

Also, the boot code should be reviewed for unnecessary casts, it seems to be a 
disease:

 triton:~/tip> git grep -cE '\(unsigned.*;$' arch/x86/boot/compressed/
 arch/x86/boot/compressed/aslr.c:14
 arch/x86/boot/compressed/eboot.c:41
 arch/x86/boot/compressed/misc.c:5
 arch/x86/boot/compressed/misc.h:2
 arch/x86/boot/compressed/mkpiggy.c:1
 arch/x86/boot/compressed/string.c:4

For example the type dance and overloaded usage that choose_kernel_location() does 
with the 'random' local variable in aslr.c is disgusting:

void choose_kernel_location(unsigned char *input,
				unsigned long input_size,
				unsigned char **output,
				unsigned long output_size,
				unsigned char **virt_offset)
{
	unsigned long random, min_addr;

	*virt_offset = (unsigned char *)LOAD_PHYSICAL_ADDR;

#ifdef CONFIG_HIBERNATION
	if (!cmdline_find_option_bool("kaslr")) {
		debug_putstr("KASLR disabled by default...\n");
		return;
	}
#else
	if (cmdline_find_option_bool("nokaslr")) {
		debug_putstr("KASLR disabled by cmdline...\n");
		return;
	}
#endif

	real_mode->hdr.loadflags |= KASLR_FLAG;

	/* Record the various known unsafe memory ranges. */
	mem_avoid_init((unsigned long)input, input_size,
		       (unsigned long)*output);

	/* Low end should be the smaller of 512M or initial location. */
	min_addr = min((unsigned long)*output, 512UL << 20);

	/* Walk e820 and find a random address. */
	random = find_random_phy_addr(min_addr, output_size);
	if (!random)
		debug_putstr("KASLR could not find suitable E820 region...\n");
	else {
		if ((unsigned long)*output != random) {
			fill_pagetable(random, output_size);
			switch_pagetable();
			*output = (unsigned char *)random;
		}
	}

	/* Pick random virtual address starting from LOAD_PHYSICAL_ADDR. */
	if (IS_ENABLED(CONFIG_X86_64))
		random = find_random_virt_offset(LOAD_PHYSICAL_ADDR,
						 output_size);
	*virt_offset = (unsigned char *)random;
}

Firstly, 'random' is a libc function name. We generally don't overload those.

Secondly, it's a random what? Variable names should make it plenty obvious. So it 
should probably be named 'random_addr'.

Third:

	/* Walk e820 and find a random address. */
	random = find_random_phy_addr(min_addr, output_size);

yeah, so what that comment tells us we knew already, due to the function name! 
What the comment should _really_ talk about is the high level purpose. Something 
like: 'Walk the e820 map and find a random free RAM address to which we can still 
decompress the whole kernel' would work so much better ...

Fourth, this function has seven (!!) type casts. We can sure do better.

Fifth:

        /* Pick random virtual address starting from LOAD_PHYSICAL_ADDR. */
        if (IS_ENABLED(CONFIG_X86_64))
                random = find_random_virt_offset(LOAD_PHYSICAL_ADDR,
                                                 output_size);
        *virt_offset = (unsigned char *)random;

So the purpose of this whole function is to pick _two_ random addresses: the 
random physical address to place the kernel at, and on x86_64, to also randomize 
the kernel virtual address, right? So exactly which comment tells us that it's 
about this? Names like 'choose_kernel_location' are singular and are actively 
misleading about this ...

... and then I haven't even mentioned small details like the imbalanced curly 
braces.

This code sucks, and I'm not surprised at all that it was broken. It should be 
improved before we can feature-extend it.

Thanks,

	Ingo
