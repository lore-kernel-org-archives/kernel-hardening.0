MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1486014168-1279-1-git-send-email-bhsharma@redhat.com>
References: <1486014168-1279-1-git-send-email-bhsharma@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 2 Feb 2017 06:21:42 -0800
Message-ID: <CAGXu5jKYMLU1f3bWism+V59cuAeQnm7Fc9zncamq9S8guGR6TQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 0/2] RFC: Adjust powerpc ASLR elf randomness
To: Bhupesh Sharma <bhsharma@redhat.com>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Daniel Cashman <dcashman@google.com>, Michael Ellerman <mpe@ellerman.id.au>, bhupesh.linux@gmail.com, Alexander Graf <agraf@suse.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Anatolij Gustschin <agust@denx.de>, Alistair Popple <alistair@popple.id.au>, Matt Porter <mporter@kernel.crashing.org>, Vitaly Bordug <vitb@kernel.crashing.org>, Scott Wood <oss@buserror.net>, Kumar Gala <galak@kernel.crashing.org>, Daniel Cashman <dcashman@android.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 1, 2017 at 9:42 PM, Bhupesh Sharma <bhsharma@redhat.com> wrote:
> This RFC patchset tries to make the powerpc ASLR elf randomness
> implementation similar to other ARCHs (like x86).
>
> The 1st patch introduces the support of ARCH_MMAP_RND_BITS in powerpc
> mmap implementation to allow a sane balance between increased randomness
> in the mmap address of ASLR elfs and increased address space
> fragmentation.
>
> The 2nd patch increases the ELF_ET_DYN_BASE value from the current
> hardcoded value of 0x2000_0000 to something more practical,
> i.e. TASK_SIZE - PAGE_SHIFT (which makes sense especially for
> 64-bit platforms which would like to utilize more randomization
> in the load address of a PIE elf).

I don't think you want this second patch. Moving ELF_ET_DYN_BASE to
the top of TASK_SIZE means you'll be constantly colliding with stack
and mmap randomization. 0x20000000 is way better since it randomizes
up from there towards the mmap area.

Is there a reason to avoid the 32-bit memory range for the ELF addresses?

-Kees

-- 
Kees Cook
Pixel Security
