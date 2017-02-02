From: Balbir Singh <bsingharora@gmail.com>
Date: Thu, 2 Feb 2017 12:14:15 +0530
Message-ID: <20170202064415.GB5179@localhost.localdomain>
References: <1486014168-1279-1-git-send-email-bhsharma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486014168-1279-1-git-send-email-bhsharma@redhat.com>
Subject: [kernel-hardening] Re: [PATCH 0/2] RFC: Adjust powerpc ASLR elf randomness
To: Bhupesh Sharma <bhsharma@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com, Alistair Popple <alistair@popple.id.au>, Anatolij Gustschin <agust@denx.de>, keescook@chromium.org, Daniel Cashman <dcashman@android.com>, Scott Wood <oss@buserror.net>, Paul Mackerras <paulus@samba.org>, dcashman@google.com, bhupesh.linux@gmail.com, Alexander Graf <agraf@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 02, 2017 at 11:12:46AM +0530, Bhupesh Sharma wrote:
> This RFC patchset tries to make the powerpc ASLR elf randomness
> implementation similar to other ARCHs (like x86).
> 
> The 1st patch introduces the support of ARCH_MMAP_RND_BITS in powerpc
> mmap implementation to allow a sane balance between increased randomness
> in the mmap address of ASLR elfs and increased address space
> fragmentation.
> 

>From what I see we get 28 bits of entropy right for 64k pages
bits as compared to 14 bits earlier?

> The 2nd patch increases the ELF_ET_DYN_BASE value from the current
> hardcoded value of 0x2000_0000 to something more practical,
> i.e. TASK_SIZE - PAGE_SHIFT (which makes sense especially for
> 64-bit platforms which would like to utilize more randomization
> in the load address of a PIE elf).
> 

This helps PIE executables as such and leaves other not impacted?

Balbir Singh
