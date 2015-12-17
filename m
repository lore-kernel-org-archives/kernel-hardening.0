Reply-To: kernel-hardening@lists.openwall.com
References: <5671B170.1090508@labbott.name>
 <1450296921.9491.1.camel@debian.org>
From: Laura Abbott <laura@labbott.name>
Message-ID: <56731502.6050601@labbott.name>
Date: Thu, 17 Dec 2015 12:03:14 -0800
MIME-Version: 1.0
In-Reply-To: <1450296921.9491.1.camel@debian.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Looking at PAX_MEMORY_SANITIZE
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 12/16/15 12:15 PM, Yves-Alexis Perez wrote:
> On mer., 2015-12-16 at 10:46 -0800, Laura Abbott wrote:
>> I'm hoping to post actual patches before I go on vacation for the holidays next
>> week. Early feedback is appreciated as well if I missed anything.
>
> Note that SANITIZE conflicted with hibernation last time I test, so that's
> something you might want to test.
>

That's a good point. I think it's only related to the page allocator which I'm
not focusing on for my first version but I'll still make sure to test before
I send that out.

Thanks,
Laura
