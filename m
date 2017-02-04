MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1486098682-30395-1-git-send-email-bhsharma@redhat.com>
References: <1486098682-30395-1-git-send-email-bhsharma@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 3 Feb 2017 16:43:51 -0800
Message-ID: <CAGXu5jJQMVJVAVQOk1zS+jRLy641fwE0NKnAme2mGbm6Y1_xeA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 1/1] powerpc: mm: support ARCH_MMAP_RND_BITS
To: Bhupesh Sharma <bhsharma@redhat.com>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Daniel Cashman <dcashman@google.com>, Michael Ellerman <mpe@ellerman.id.au>, Bhupesh SHARMA <bhupesh.linux@gmail.com>, Alexander Graf <agraf@suse.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Anatolij Gustschin <agust@denx.de>, Alistair Popple <alistair@popple.id.au>, Matt Porter <mporter@kernel.crashing.org>, Vitaly Bordug <vitb@kernel.crashing.org>, Scott Wood <oss@buserror.net>, Kumar Gala <galak@kernel.crashing.org>, Daniel Cashman <dcashman@android.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 2, 2017 at 9:11 PM, Bhupesh Sharma <bhsharma@redhat.com> wrote:
> powerpc: arch_mmap_rnd() uses hard-coded values, (23-PAGE_SHIFT) for
> 32-bit and (30-PAGE_SHIFT) for 64-bit, to generate the random offset
> for the mmap base address.
>
> This value represents a compromise between increased
> ASLR effectiveness and avoiding address-space fragmentation.
> Replace it with a Kconfig option, which is sensibly bounded, so that
> platform developers may choose where to place this compromise.
> Keep default values as new minimums.
>
> This patch makes sure that now powerpc mmap arch_mmap_rnd() approach
> is similar to other ARCHs like x86, arm64 and arm.
>
> Cc: Alexander Graf <agraf@suse.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Anatolij Gustschin <agust@denx.de>
> Cc: Alistair Popple <alistair@popple.id.au>
> Cc: Matt Porter <mporter@kernel.crashing.org>
> Cc: Vitaly Bordug <vitb@kernel.crashing.org>
> Cc: Scott Wood <oss@buserror.net>
> Cc: Kumar Gala <galak@kernel.crashing.org>
> Cc: Daniel Cashman <dcashman@android.com>
> Signed-off-by: Bhupesh Sharma <bhsharma@redhat.com>
> Reviewed-by: Kees Cook <keescook at chromium.org>

This " at " should be "@", but otherwise, yay v2! :)

-Kees

-- 
Kees Cook
Pixel Security
