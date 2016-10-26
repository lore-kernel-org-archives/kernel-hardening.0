Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BF8C0A@IRSMSX102.ger.corp.intel.com>
References: <20161025204303.GA36052@beast> <2236FBA76BA1254E88B949DDB74E612B41BF8C0A@IRSMSX102.ger.corp.intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 26 Oct 2016 13:41:34 -0700
Message-ID: <CAGXu5jJ2MmY=qDT420F9_hbKtkdRvXC+Juf0J8WKJmtZN4jC0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v2 PATCH 13.1/13] lkdtm: add tests for atomic over-/underflow
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 26, 2016 at 12:29 AM, Reshetova, Elena
<elena.reshetova@intel.com> wrote:
> Thank you Kees! I applied the commit to our hardened_atomic_on_next branch and it will be included into the next rfc.

Cool, thanks. I assume this should get atomic64_t and local_t tests as well?

-Kees

-- 
Kees Cook
Nexus Security
