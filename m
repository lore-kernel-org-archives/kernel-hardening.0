MIME-Version: 1.0
In-Reply-To: <20170202091136.GC5179@localhost.localdomain>
References: <1486014168-1279-1-git-send-email-bhsharma@redhat.com>
 <1486014168-1279-2-git-send-email-bhsharma@redhat.com> <20170202091136.GC5179@localhost.localdomain>
From: Bhupesh Sharma <bhsharma@redhat.com>
Date: Thu, 2 Feb 2017 23:44:17 +0530
Message-ID: <CACi5LpM7s_Z_BuU=NL6Np4L2qoPysLhwcnP_3M24UE_LnFpRRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 1/2] powerpc: mm: support ARCH_MMAP_RND_BITS
To: Balbir Singh <bsingharora@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com, Alistair Popple <alistair@popple.id.au>, Anatolij Gustschin <agust@denx.de>, Kees Cook <keescook@chromium.org>, Daniel Cashman <dcashman@android.com>, Scott Wood <oss@buserror.net>, Paul Mackerras <paulus@samba.org>, Daniel Cashman <dcashman@google.com>, Bhupesh SHARMA <bhupesh.linux@gmail.com>, Alexander Graf <agraf@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

HI Balbir,

On Thu, Feb 2, 2017 at 2:41 PM, Balbir Singh <bsingharora@gmail.com> wrote:
>> @@ -100,6 +132,8 @@ config PPC
>>       select HAVE_EFFICIENT_UNALIGNED_ACCESS if !(CPU_LITTLE_ENDIAN && POWER7_CPU)
>>       select HAVE_KPROBES
>>       select HAVE_ARCH_KGDB
>> +     select HAVE_ARCH_MMAP_RND_BITS
>> +     select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
>
> COMPAT is on for ppc64 by default, so we'll end up with COMPAT_BITS same
> as before all the time.


No, actually the 'ARCH_MMAP_RND_COMPAT_BITS'  values can be changed
after boot using the '/proc/sys/vm/mmap_rnd_compat_bits' tunable:

http://lxr.free-electrons.com/source/arch/Kconfig#L624

Regards,
Bhupesh
