Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161027124652.2pys4h7tug5wmqge@thigreal>
References: <20161025204303.GA36052@beast> <2236FBA76BA1254E88B949DDB74E612B41BF8C0A@IRSMSX102.ger.corp.intel.com>
 <CAGXu5jJ2MmY=qDT420F9_hbKtkdRvXC+Juf0J8WKJmtZN4jC0g@mail.gmail.com> <20161027124652.2pys4h7tug5wmqge@thigreal>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 27 Oct 2016 14:36:25 -0700
Message-ID: <CAGXu5jLnuny-rEcck5SKnORqFU0=Jqt8Pzomv+KdL7JRrB=S5A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v2 PATCH 13.1/13] lkdtm: add tests for atomic over-/underflow
To: Hans Liljestrand <ishkamiel@gmail.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, David Windsor <dwindsor@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 27, 2016 at 5:46 AM, Hans Liljestrand <ishkamiel@gmail.com> wrote:
> On Wed, Oct 26, 2016 at 01:41:34PM -0700, Kees Cook wrote:
>> On Wed, Oct 26, 2016 at 12:29 AM, Reshetova, Elena
>> <elena.reshetova@intel.com> wrote:
>> > Thank you Kees! I applied the commit to our hardened_atomic_on_next branch and it will be included into the next rfc.
>>
>> Cool, thanks. I assume this should get atomic64_t and local_t tests as well?
>>
>
> Yes, I'm currently compiling a build with atomic64_t and local_t tests added.
> With the improved lkdtm macros its much easier to add the extra types, thank
> you Kees!

Sure thing! I may have yet-another patch for this, as I didn't like
repeating the same things in three files whenever a new test was
added. Moar macro magick!

-Kees

-- 
Kees Cook
Nexus Security
