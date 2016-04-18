Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160418144605.GF3886@suse.de>
References: <1460757793-59020-1-git-send-email-thgarnie@google.com>
	<1460757793-59020-4-git-send-email-thgarnie@google.com>
	<20160418144605.GF3886@suse.de>
Date: Mon, 18 Apr 2016 07:56:45 -0700
Message-ID: <CAJcbSZHOYb2vnuLh4i1ivfonmzWLPZX3u4TFTG8XAjXXhaR2gQ@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v1 3/4] x86, boot: Implement ASLR for kernel memory sections (x86_64)
To: Joerg Roedel <jroedel@suse.de>
Cc: "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Seth Jennings <sjennings@variantweb.net>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Greg Thelen <gthelen@google.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Yes, it is. Certainly happened while editing patches (sorry about
that), will be fixed on next iteration once I get a bit more feedback.

On Mon, Apr 18, 2016 at 7:46 AM, Joerg Roedel <jroedel@suse.de> wrote:
> On Fri, Apr 15, 2016 at 03:03:12PM -0700, Thomas Garnier wrote:
>> +#if defined(CONFIG_KASAN)
>> +static const unsigned long memory_rand_end = KASAN_SHADOW_START;
>> +#elfif defined(CONFIG_X86_ESPFIX64)
>> +static const unsigned long memory_rand_end = ESPFIX_BASE_ADDR;
>> +#elfif defined(CONFIG_EFI)
>> +static const unsigned long memory_rand_end = EFI_VA_START;
>> +#else
>> +static const unsigned long memory_rand_end = __START_KERNEL_map;
>> +#endif
>
> That #elfif is a typo, right?
>
>
>         Joerg
>
