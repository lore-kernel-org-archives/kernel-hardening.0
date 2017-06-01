References: <20170529213800.29438-1-matt@nmatt.com>
 <20170529213800.29438-3-matt@nmatt.com>
 <20170529232640.16211960@alans-desktop>
 <CAFUG7CdDd0Yfegb1S6_wNQzje4EuLE0jPdvOE=uSQL152meyjQ@mail.gmail.com>
 <3738951f-7a4a-b37f-c695-21a2fcd45f76@schaufler-ca.com>
 <0e078ce7-5b62-f27c-3920-efc2ffdf342b@nmatt.com>
 <b0a29f23-4154-8f2f-98e7-0942612f0cdc@schaufler-ca.com>
 <e1c9e4e8-5427-b4b6-aad2-72c88552a6af@nmatt.com>
 <20170530132427.016053da@alans-desktop>
 <2ab8580e-bf8e-21bd-6bfa-33e5fa82400b@nmatt.com>
 <20170530235106.11aab25c@alans-desktop>
 <3bd4ff7b-6f7d-52b0-03f6-026bac79f11f@nmatt.com>
 <20170531005633.484a2e14@alans-desktop>
 <CAGXu5j+pqD1082fYDS_dvDB2QNvt9wSz+C7vAhGpMXcJWxoDkw@mail.gmail.com>
From: lazytyped <lazytyped@gmail.com>
Message-ID: <6e713105-02db-12e1-68a9-f167fe11d0a9@gmail.com>
Date: Thu, 1 Jun 2017 09:12:07 +0200
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+pqD1082fYDS_dvDB2QNvt9wSz+C7vAhGpMXcJWxoDkw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 6/1/17 4:35 AM, Kees Cook wrote:
> I still cannot wrap my head around why providing users with a
> protection is a bad thing. Yes, the other tty games are bad, but this
> fixes a specific and especially bad case that is easy to kill. It's
> got a Kconfig and a sysctl. It's not on by default. This protects the
> common case of privileged ttys that aren't attached to consoles, etc,
> so while the framebuffer thing is an issue, it's not always an issue,
> etc.
There are a couple of reasons for that:

First of all, a protection is extra cost, in terms of maintenance, 
knowledge (a new knob) and compatibility. That extra cost may sound 
minimal, but adds up pretty quickly. If the protection is "easily" 
bypassable (that is, today we use TIOCSTI, tomorrow we use something 
else in the same path), then that extra cost/complexity stays for no 
good reason. Feature creep is a real issue, in security, IMHO - it's not 
a 'number of features' game.

Second, stuff that is delivered off by default tends to rot. I don't 
work on Linux, but generally try really hard to not add something that 
is not ON by default at least for a small number of things. Stuff 
inevitably breaks, and it's extra cost.
To me, a protection that needs to be off by default, raises a red flag. 
I know Linux has a somewhat different philosophy (centered around the 
kernel config that each distribution pieces together and ships), so 
mileage probably varies there.

I don't have enough skills to comment about all the possible TTY attacks 
and quirks, but I think I understand where Alan comes from.

Good luck.


          -  Enrico
