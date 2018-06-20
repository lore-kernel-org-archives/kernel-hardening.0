MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <12014310-19f7-dc31-d983-9c7e00c8b446@infradead.org>
References: <1529532570-21765-1-git-send-email-rick.p.edgecombe@intel.com>
 <1529532570-21765-2-git-send-email-rick.p.edgecombe@intel.com> <12014310-19f7-dc31-d983-9c7e00c8b446@infradead.org>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 20 Jun 2018 15:35:10 -0700
Message-ID: <CAGXu5j+RgbMKqiBcsWMOZ-ci-rT19imgCoHtPKgDURF1tC+COg@mail.gmail.com>
Subject: Re: [PATCH 1/3] vmalloc: Add __vmalloc_node_try_addr function
Content-Type: text/plain; charset="UTF-8"
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, kristen Accardi <kristen.c.accardi@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 20, 2018 at 3:16 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 06/20/2018 03:09 PM, Rick Edgecombe wrote:
>> +void *__vmalloc_node_try_addr(unsigned long addr, unsigned long size,
>> +                     gfp_t gfp_mask, pgprot_t prot, unsigned long vm_flags,
>> +                     int node, const void *caller)
>> +{
>
> so this isn't optional, eh?  You are going to force it on people because?

RANDOMIZE_BASE isn't optional either. :) This improves the module
address entropy with (what seems to be) no down-side, so yeah, I think
it should be non-optional. :)

-Kees

-- 
Kees Cook
Pixel Security
