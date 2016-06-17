Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 17 Jun 2016 11:07:30 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160617090730.GD4791@gmail.com>
References: <1460757793-59020-1-git-send-email-thgarnie@google.com>
 <1460757793-59020-4-git-send-email-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1460757793-59020-4-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] Re: [RFC v1 3/4] x86, boot: Implement ASLR for kernel memory
 sections (x86_64)
To: Thomas Garnier <thgarnie@google.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Seth Jennings <sjennings@variantweb.net>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, gthelen@google.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


* Thomas Garnier <thgarnie@google.com> wrote:

>  arch/x86/include/asm/kaslr.h            |  12 +++

Hm, what tree is this patch against? asm/kaslr.h does not exist upstream or in the 
x86 tree.

Thanks,

	Ingo
