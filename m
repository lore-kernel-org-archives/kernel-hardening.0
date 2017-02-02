From: Balbir Singh <bsingharora@gmail.com>
Date: Thu, 2 Feb 2017 14:41:36 +0530
Message-ID: <20170202091136.GC5179@localhost.localdomain>
References: <1486014168-1279-1-git-send-email-bhsharma@redhat.com>
 <1486014168-1279-2-git-send-email-bhsharma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486014168-1279-2-git-send-email-bhsharma@redhat.com>
Subject: [kernel-hardening] Re: [PATCH 1/2] powerpc: mm: support ARCH_MMAP_RND_BITS
To: Bhupesh Sharma <bhsharma@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com, Alistair Popple <alistair@popple.id.au>, Anatolij Gustschin <agust@denx.de>, keescook@chromium.org, Daniel Cashman <dcashman@android.com>, Scott Wood <oss@buserror.net>, Paul Mackerras <paulus@samba.org>, dcashman@google.com, bhupesh.linux@gmail.com, Alexander Graf <agraf@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

> @@ -100,6 +132,8 @@ config PPC
>  	select HAVE_EFFICIENT_UNALIGNED_ACCESS if !(CPU_LITTLE_ENDIAN && POWER7_CPU)
>  	select HAVE_KPROBES
>  	select HAVE_ARCH_KGDB
> +	select HAVE_ARCH_MMAP_RND_BITS
> +	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT

COMPAT is on for ppc64 by default, so we'll end up with COMPAT_BITS same
as before all the time.

Balbir Singh.
