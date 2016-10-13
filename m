Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 13 Oct 2016 17:31:59 +0300
From: Hans Liljestrand <ishkamiel@gmail.com>
Message-ID: <20161013143159.GA3525@thigreal>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
 <1475476886-26232-2-git-send-email-elena.reshetova@intel.com>
 <CAGXu5j+7_cd4GgX46wSMv9LHpogwH7qrU8=K8OPEed4hCGr65g@mail.gmail.com>
 <20161012082634.GK19531@linaro.org>
 <2236FBA76BA1254E88B949DDB74E612B41BDDB97@IRSMSX102.ger.corp.intel.com>
 <CAGXu5j+X4TkaZN2pQseWKBAjbirF06aUMjGqZ2La3ODGutFf8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+X4TkaZN2pQseWKBAjbirF06aUMjGqZ2La3ODGutFf8A@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 01/13] Add architecture
 independent hardened atomic base
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 12, 2016 at 03:50:12PM -0700, Kees Cook wrote:
> On Wed, Oct 12, 2016 at 10:25 AM, Reshetova, Elena
> <elena.reshetova@intel.com> wrote:
> > Yes, same story, now we are not calling it, but things change obviously. We wanted to start somewhere, and this set is already quite big even with the current needs.
> > So, does everyone agree that we should provide full coverage?
> 
> I think it makes sense. That means no one wanting the function ends up
> with a surprise depending on CONFIG selection, etc.
> 

Yes, sounds reasonable, I will get started on this tomorrow.

Once I get that sorted I'll also check on our lkdtm coverage, since I'm pretty
sure it's somewhat spotty even before any new implementations.

Best Regards,
-hans
