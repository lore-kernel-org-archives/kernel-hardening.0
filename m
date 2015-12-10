Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 9 Dec 2015 16:00:05 -0800
From: David Brown <david.brown@linaro.org>
Message-ID: <20151210000005.GA99337@davidb.org>
References: <20151209172101.GA70633@davidb.org>
 <CAGXu5jLPidHzHwmn5kzK0iSCAehABgtiEzMWgyBvw8iQ-pt=8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGXu5jLPidHzHwmn5kzK0iSCAehABgtiEzMWgyBvw8iQ-pt=8g@mail.gmail.com>
Subject: Re: [kernel-hardening] Self Introduction
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 09, 2015 at 02:19:24PM -0800, Kees Cook wrote:
>On Wed, Dec 9, 2015 at 9:21 AM, David Brown <david.brown@linaro.org> wrote:
>> Per "Get Involved" on the Kernel Self Protection Project wiki, I'm
>> introducing myself.
>>
>> I have recently joined Linaro on the Security Working Group.  As such,
>> I expect to seen be getting involved with the various kernel hardening
>> and related projects.
>
>Welcome to the mailing list. :)
>
>What sorts of things are you interested in working on?

A while back, I'd gone through each of the features in grsecurity and
PAX.  There were a number that seemed good from a security point of
view, but difficult in terms of culture within the kernel.  I've just
started up going through these again, as well as reading the kernel
hardening wiki, and I should soon have a better idea of what would be
good to work on.  My scope is broad enough that I want to get a good
idea of where others want to go as well, as well as what brings good
benefit.

I suspect part of the challenge is going to be clearly describing the
various features along with specific examples of already-discovered
exploits that the feature would have mitigated.

Most recently, I backported ARM PAN support to the Linaro stable
kernels (3.18 and 4.1).

David
