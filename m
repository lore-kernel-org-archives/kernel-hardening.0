Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 7 Sep 2011 15:14:38 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110907111438.GA12044@albatros>
References: <20110808143603.GA3695@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110808143603.GA3695@albatros>
Subject: [kernel-hardening] Re: [PATCH] Remove a.out library support in ELF loader
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: kernel-hardening@lists.openwall.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Mon, Aug 08, 2011 at 18:36 +0400, Vasiliy Kulikov wrote:
> Commit d20894a23708c2 has removed the part of a.out code related to the
> executables, but kept a.out library code as-is.  Remove it.

Alexander, can you please merge the patch?  No comments for one month,
probably it means that it's good :)

> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  fs/binfmt_elf.c |   85 -------------------------------------------------------
>  1 files changed, 0 insertions(+), 85 deletions(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 303983f..3416674 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -37,7 +37,6 @@
>  #include <asm/page.h>
>  
>  static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
> -static int load_elf_library(struct file *);
>  static unsigned long elf_map(struct file *, unsigned long, struct elf_phdr *,
>  				int, int, unsigned long);
>  
> @@ -68,7 +67,6 @@ static int elf_core_dump(struct coredump_params *cprm);
>  static struct linux_binfmt elf_format = {
>  	.module		= THIS_MODULE,
>  	.load_binary	= load_elf_binary,
> -	.load_shlib	= load_elf_library,
>  	.core_dump	= elf_core_dump,
>  	.min_coredump	= ELF_EXEC_PAGESIZE,
>  };
> @@ -994,89 +992,6 @@ out_free_ph:
>  	goto out;
>  }
>  
> -/* This is really simpleminded and specialized - we are loading an
> -   a.out library that is given an ELF header. */
> -static int load_elf_library(struct file *file)
> -{
> -	struct elf_phdr *elf_phdata;
> -	struct elf_phdr *eppnt;
> -	unsigned long elf_bss, bss, len;
> -	int retval, error, i, j;
> -	struct elfhdr elf_ex;
> -
> -	error = -ENOEXEC;
> -	retval = kernel_read(file, 0, (char *)&elf_ex, sizeof(elf_ex));
> -	if (retval != sizeof(elf_ex))
> -		goto out;
> -
> -	if (memcmp(elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
> -		goto out;
> -
> -	/* First of all, some simple consistency checks */
> -	if (elf_ex.e_type != ET_EXEC || elf_ex.e_phnum > 2 ||
> -	    !elf_check_arch(&elf_ex) || !file->f_op || !file->f_op->mmap)
> -		goto out;
> -
> -	/* Now read in all of the header information */
> -
> -	j = sizeof(struct elf_phdr) * elf_ex.e_phnum;
> -	/* j < ELF_MIN_ALIGN because elf_ex.e_phnum <= 2 */
> -
> -	error = -ENOMEM;
> -	elf_phdata = kmalloc(j, GFP_KERNEL);
> -	if (!elf_phdata)
> -		goto out;
> -
> -	eppnt = elf_phdata;
> -	error = -ENOEXEC;
> -	retval = kernel_read(file, elf_ex.e_phoff, (char *)eppnt, j);
> -	if (retval != j)
> -		goto out_free_ph;
> -
> -	for (j = 0, i = 0; i<elf_ex.e_phnum; i++)
> -		if ((eppnt + i)->p_type == PT_LOAD)
> -			j++;
> -	if (j != 1)
> -		goto out_free_ph;
> -
> -	while (eppnt->p_type != PT_LOAD)
> -		eppnt++;
> -
> -	/* Now use mmap to map the library into memory. */
> -	down_write(&current->mm->mmap_sem);
> -	error = do_mmap(file,
> -			ELF_PAGESTART(eppnt->p_vaddr),
> -			(eppnt->p_filesz +
> -			 ELF_PAGEOFFSET(eppnt->p_vaddr)),
> -			PROT_READ | PROT_WRITE | PROT_EXEC,
> -			MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE,
> -			(eppnt->p_offset -
> -			 ELF_PAGEOFFSET(eppnt->p_vaddr)));
> -	up_write(&current->mm->mmap_sem);
> -	if (error != ELF_PAGESTART(eppnt->p_vaddr))
> -		goto out_free_ph;
> -
> -	elf_bss = eppnt->p_vaddr + eppnt->p_filesz;
> -	if (padzero(elf_bss)) {
> -		error = -EFAULT;
> -		goto out_free_ph;
> -	}
> -
> -	len = ELF_PAGESTART(eppnt->p_filesz + eppnt->p_vaddr +
> -			    ELF_MIN_ALIGN - 1);
> -	bss = eppnt->p_memsz + eppnt->p_vaddr;
> -	if (bss > len) {
> -		down_write(&current->mm->mmap_sem);
> -		do_brk(len, bss - len);
> -		up_write(&current->mm->mmap_sem);
> -	}
> -	error = 0;
> -
> -out_free_ph:
> -	kfree(elf_phdata);
> -out:
> -	return error;
> -}
>  
>  #ifdef CONFIG_ELF_CORE
>  /*
> -- 
> 1.7.0.4
> 

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
