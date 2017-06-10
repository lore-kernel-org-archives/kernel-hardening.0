References: <CAFwXZv_b3hdEA4xOFKqAVfc4UZEBX=dL9DOY_mDHExsW+Qg6tQ@mail.gmail.com>
 <85inkpie9o.fsf@boum.org> <20170525154818.2mj5xp7dywty4nje@thunk.org>
 <0bbee9e4-78b5-c7d9-369f-2f2d9a480bf3@nmatt.com>
From: HacKurx <hackurx@gmail.com>
Message-ID: <358ca0aa-e2fb-d451-48bf-1edcb2251fe4@gmail.com>
Date: Sat, 10 Jun 2017 09:00:53 +0200
MIME-Version: 1.0
In-Reply-To: <0bbee9e4-78b5-c7d9-369f-2f2d9a480bf3@nmatt.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] Patch for random mac address
To: Matt Brown <matt@nmatt.com>, Theodore Ts'o <tytso@mit.edu>, intrigeri <intrigeri@boum.org>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Le 09/06/2017 à 15:11, Matt Brown a écrit :

> On 5/25/17 11:48 AM, Theodore Ts'o wrote:
>> On Thu, May 25, 2017 at 09:31:15AM +0200, intrigeri wrote:
>>> HacKurx:
>>>> Because this would be useful for distributions like Tails, Subgraph
>>>> OS, Kali Linux and other ...
>>> For what it's worth, it's unlikely that Tails ever uses this unless it
>>> can be controlled at runtime from userspace: we need to give users an
>>> option to disable MAC address randomization, because it breaks network
>>> connectivity in some cases.
>> BTW, in case people aren't aware ---- you can set the MAC address from
>> userspace already:
>>
>> Package: macchanger
>
> Yeah I've used this program before. If you want it to always run at boot
> you can write a service script for your init system of choice and set it
> to run on start up.
>
> In what way does this patch protect you more than a start up script as
> described above?
>
> Matt
Because macchanger use the kernel...
It is loaded too late and increases the risk of the MAC address does not change. See:
https://github.com/alobbs/macchanger/issues

Does your startup script depend on systemd? Who it depends on udev and recommend dbus ...
Is the permanent MAC address stored in the system logs (boot, ipv6, firewall) ?
If a user use journalctl under ubuntu he could see this without sudo ...

For me randomize MAC in a kernel is be the best method to do this.

Loic
