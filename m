Reply-To: kernel-hardening@lists.openwall.com
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
 <1475476886-26232-2-git-send-email-elena.reshetova@intel.com>
 <CAGXu5j+7_cd4GgX46wSMv9LHpogwH7qrU8=K8OPEed4hCGr65g@mail.gmail.com>
 <CAEXv5_h55L8UyYpFy6qQUPBqGfxOOR+DEXywbNVkBb89a336UQ@mail.gmail.com>
 <CAGXu5jLitFEp__P43VYqvq42At9qMo2_wpf=AR-8sDkmS06_LQ@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41BDAC2F@IRSMSX102.ger.corp.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <57F51E29.9040408@intel.com>
Date: Wed, 5 Oct 2016 08:37:13 -0700
MIME-Version: 1.0
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BDAC2F@IRSMSX102.ger.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC PATCH 01/13] Add architecture independent hardened atomic
 base
To: "Reshetova, Elena" <elena.reshetova@intel.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 10/04/2016 12:05 AM, Reshetova, Elena wrote:
>> >This could also be the basis for Dave Hanson's suggestion to use
>> >cmpchxg: would the expense of that instead of locked addl get noticed, etc?
> Do you mean cmpxchg? Dave, I could not find your suggestion, which mail thread was it?

Using cmpxchg() is implied if we use atomic_add_unless().  So it was a
part of my suggestion to use atomic_add_unless().
