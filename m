Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 27 Oct 2016 15:46:52 +0300
From: Hans Liljestrand <ishkamiel@gmail.com>
Message-ID: <20161027124652.2pys4h7tug5wmqge@thigreal>
References: <20161025204303.GA36052@beast>
 <2236FBA76BA1254E88B949DDB74E612B41BF8C0A@IRSMSX102.ger.corp.intel.com>
 <CAGXu5jJ2MmY=qDT420F9_hbKtkdRvXC+Juf0J8WKJmtZN4jC0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ2MmY=qDT420F9_hbKtkdRvXC+Juf0J8WKJmtZN4jC0g@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC v2 PATCH 13.1/13] lkdtm: add tests for atomic
 over-/underflow
To: Kees Cook <keescook@chromium.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, David Windsor <dwindsor@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 26, 2016 at 01:41:34PM -0700, Kees Cook wrote:
> On Wed, Oct 26, 2016 at 12:29 AM, Reshetova, Elena
> <elena.reshetova@intel.com> wrote:
> > Thank you Kees! I applied the commit to our hardened_atomic_on_next branch and it will be included into the next rfc.
> 
> Cool, thanks. I assume this should get atomic64_t and local_t tests as well?
> 

Yes, I'm currently compiling a build with atomic64_t and local_t tests added.
With the improved lkdtm macros its much easier to add the extra types, thank
you Kees!

Regards,
-hans
