References: <CAFwXZv_b3hdEA4xOFKqAVfc4UZEBX=dL9DOY_mDHExsW+Qg6tQ@mail.gmail.com>
 <85inkpie9o.fsf@boum.org> <20170525154818.2mj5xp7dywty4nje@thunk.org>
From: Matt Brown <matt@nmatt.com>
Message-ID: <0bbee9e4-78b5-c7d9-369f-2f2d9a480bf3@nmatt.com>
Date: Fri, 9 Jun 2017 09:11:54 -0400
MIME-Version: 1.0
In-Reply-To: <20170525154818.2mj5xp7dywty4nje@thunk.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Patch for random mac address
To: Theodore Ts'o <tytso@mit.edu>, intrigeri <intrigeri@boum.org>, HacKurx <hackurx@gmail.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 5/25/17 11:48 AM, Theodore Ts'o wrote:
> On Thu, May 25, 2017 at 09:31:15AM +0200, intrigeri wrote:
>>
>> HacKurx:
>>> Because this would be useful for distributions like Tails, Subgraph
>>> OS, Kali Linux and other ...
>>
>> For what it's worth, it's unlikely that Tails ever uses this unless it
>> can be controlled at runtime from userspace: we need to give users an
>> option to disable MAC address randomization, because it breaks network
>> connectivity in some cases.
> 
> BTW, in case people aren't aware ---- you can set the MAC address from
> userspace already:
> 
> Package: macchanger


Yeah I've used this program before. If you want it to always run at boot
you can write a service script for your init system of choice and set it
to run on start up.

In what way does this patch protect you more than a start up script as
described above?

Matt
