Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <56731502.6050601@labbott.name>
References: <5671B170.1090508@labbott.name>
	<1450296921.9491.1.camel@debian.org>
	<56731502.6050601@labbott.name>
Date: Thu, 17 Dec 2015 12:15:15 -0800
Message-ID: <CAGXu5jJvgoN+JwCP+ZT==nZap2WFPvCRe02mR6bymSoG-Om6Mw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Looking at PAX_MEMORY_SANITIZE
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 17, 2015 at 12:03 PM, Laura Abbott <laura@labbott.name> wrote:
> On 12/16/15 12:15 PM, Yves-Alexis Perez wrote:
>>
>> On mer., 2015-12-16 at 10:46 -0800, Laura Abbott wrote:
>>>
>>> I'm hoping to post actual patches before I go on vacation for the
>>> holidays next
>>> week. Early feedback is appreciated as well if I missed anything.
>>
>>
>> Note that SANITIZE conflicted with hibernation last time I test, so that's
>> something you might want to test.
>>
>
> That's a good point. I think it's only related to the page allocator which
> I'm
> not focusing on for my first version but I'll still make sure to test before
> I send that out.

It's also easy now to have runtime conflict with hibernation (this is
what kASLR does to avoid a CONFIG conflict with hibernation, via
__setup("kaslr", kaslr_nohibernate_setup)).

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
