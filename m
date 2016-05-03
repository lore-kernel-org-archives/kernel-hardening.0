Reply-To: kernel-hardening@lists.openwall.com
References: <1462225276-106993-1-git-send-email-thgarnie@google.com>
 <1462225276-106993-3-git-send-email-thgarnie@google.com>
 <5727CD69.7040901@linux.intel.com> <20160503100530.GC3287@x1.redhat.com>
From: Dave Hansen <dave.hansen@linux.intel.com>
Message-ID: <5728BF03.1050303@linux.intel.com>
Date: Tue, 3 May 2016 08:08:51 -0700
MIME-Version: 1.0
In-Reply-To: <20160503100530.GC3287@x1.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 2/4] x86, boot: PUD VA support for physical mapping
 (x86_64)
To: Baoquan He <bhe@redhat.com>
Cc: Thomas Garnier <thgarnie@google.com>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, Mark Salter <msalter@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, gthelen@google.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 05/03/2016 03:05 AM, Baoquan He wrote:
> I have a tiny concern about phys_pmd_init(), both phys_pud_init and
> phys_pte_init name 2nd parameter as 'addr', phys_pmd_init use 'address'.
> If this can be changed to make them look consistent completist would
> have a good sleep from now on.

Yes, consistency would be nice.  Even better would be to call them all
'phys_addr'.
