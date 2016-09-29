Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 29 Sep 2016 09:43:24 +0200
From: Simon Horman <horms@verge.net.au>
Message-ID: <20160929074324.GD14497@verge.net.au>
References: <1473750605-5955-1-git-send-email-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473750605-5955-1-git-send-email-bhe@redhat.com>
Subject: [kernel-hardening] Re: [PATCH v1] kexec/arch/i386: Add support for KASLR memory
 randomization
To: Baoquan He <bhe@redhat.com>
Cc: tonli@redhat.com, kexec@lists.infradead.org, Thomas Garnier <thgarnie@google.com>, keescook@chromium.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Sep 13, 2016 at 03:10:05PM +0800, Baoquan He wrote:
> From: Thomas Garnier <thgarnie@google.com>
> 
> Multiple changes were made on KASLR (right now in linux-next). One of
> them is randomizing the virtual address of the physical mapping, vmalloc
> and vmemmap memory sections. It breaks kdump ability to read physical
> memory.
> 
> This change identifies if KASLR memories randomization is used by
> checking if the page_offset_base variable exists. It search for the
> correct PAGE_OFFSET value by looking at the loaded memory section and
> find the lowest aligned on PUD (the randomization level).
> 
> Related commits on linux-next:
>  - 0483e1fa6e09d4948272680f691dccb1edb9677f: Base for randomization
>  - 021182e52fe01c1f7b126f97fd6ba048dc4234fd: Enable for PAGE_OFFSET
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

Thanks, applied.
