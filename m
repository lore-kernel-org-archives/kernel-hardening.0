Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BF8853@IRSMSX102.ger.corp.intel.com>
References: <201610251247.sRs00hNq%fengguang.wu@intel.com> <CAEXv5_jPfV9aV1KP=cmoBMGXuCCVEtXZhGmvtuFAL8qfLi+oYA@mail.gmail.com>
 <20161025125510.iuia42t3qdow5yer@thigreal> <CAGXu5j+QU3MHfjG7NVRh2MsK9sESoJpJ6S6h5MdR52NAVM=--Q@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41BF8853@IRSMSX102.ger.corp.intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 25 Oct 2016 15:00:55 -0700
Message-ID: <CAGXu5j+4tdxJbQGu+ShqdGOR_Y30G4hrYk7OZ2RJa75ptUcPfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [kees:kspp/hardened-atomic 3/14] kernel/trace/ring_buffer.c:299:2:
 error: unknown type name 'local_wrap_t'
To: "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 25, 2016 at 11:14 AM, Reshetova, Elena
<elena.reshetova@intel.com> wrote:
>>I pulled in the RFC v2, and since it was based on a prior -next, I ended up choosing 4.9-rc2 to base it on since it had fewer conflicts.
>
> I guess I need to do a rebase. Do we still want to keep it on top of next?

I defer to your preference, though -next is a moving target, so at
some point here we'll need to just base it on Linus's tree, but that
might make some merges more difficult.

What do other folks find easier to test with?

-Kees

-- 
Kees Cook
Nexus Security
