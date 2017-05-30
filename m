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
From: Matt Brown <matt@nmatt.com>
Message-ID: <3bd4ff7b-6f7d-52b0-03f6-026bac79f11f@nmatt.com>
Date: Tue, 30 May 2017 19:19:05 -0400
MIME-Version: 1.0
In-Reply-To: <20170530235106.11aab25c@alans-desktop>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Casey Schaufler <casey@schaufler-ca.com>, Boris Lukashev <blukashev@sempervictus.com>, Greg KH <gregkh@linuxfoundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 5/30/17 6:51 PM, Alan Cox wrote:
> On Tue, 30 May 2017 12:28:59 -0400
> Matt Brown <matt@nmatt.com> wrote:
> 
>> On 5/30/17 8:24 AM, Alan Cox wrote:
>>> Look there are two problems here
>>>
>>> 1. TIOCSTI has users  
>>
>> I don't see how this is a problem.
> 
> Which is unfortunate. To start with if it didn't have users we could just
> delete it.
> 
>>>
>>> 2. You don't actually fix anything
>>>
>>> The underlying problem is that if you give your tty handle to another
>>> process which you don't trust you are screwed. It's fundamental to the
>>> design of the Unix tty model and it's made worse in Linux by the fact
>>> that we use the tty descriptor to access all sorts of other console state
>>> (which makes a ton of sense).
>>>
>>> Many years ago a few people got this wrong. All those apps got fixes back
>>> then. They allocate a tty/pty pair and create a new session over that.
>>> The potentially hostile other app only gets to screw itself.
>>>   
>>
>> Many years ago? We already got one in 2017, as well as a bunch last year.
>> See: https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=tiocsti
> 
> All the apps got fixed at the time. The fact the next generation of
> forgot to learn from it is unfortunate but hardly new. Also every single
> one of those that exposes a tty in that way allows other annoying
> behaviours via other ioctl interfaces so none of them would have been
> properly mitigated.
> 

This is my point. Apps will continue to shoot themselves in the foot. Of course
the correct response to one of these vulns is to not pass ttys across a
security boundary. We have an opportunity here to reduce the impact of this bug
class at the kernel level. Rejecting this mitigation because the real solution
is to use a tty/pty pair is like saying we should reject ASLR because the real
solution to buffer overflows is proper bounds checking.

> If you really want to do that particular bit of snake oiling then you can
> use the existing SELinux, seccomp and related interfaces. They can even
> do the job properly by whitelisting or blocking long lists of ioctls.
> 
>> This protections seeks to protect users from programs that don't do things
>> correctly. Rather than killing bugs, this feature attempts to kill an entire
>> bug class that shows little sign of slowing down in the world of containers and
>> sandboxes.
> 
> Well maybe the people writing them need to learn what they are doing and
> stop passing random file descriptors into their container (I've even seen
> people handing X file handles into their 'container').
> 
> The kernel can do some things to help programmers but it can't stop
> people writing crap. Anyone writing code that crosses security boundaries
> should have at least a vague idea of what they are doing.
> 
> The only way you'd actually really prevent this would be to magically
> open a new pty/tty pair and substitute the file handlers plus a data
> copying thread when someone created a namespace.
> 
> Now you can actually do that with the ptrace functionality in seccomp but
> it would still be fairly insane to expect the kernel to handle.
> 
> Alan
> [Actually even more sensible would be to revert the entire sorry
> container mess and use VMs but it's a bit late for that ;-)]
> 

Totally agree. VMs >> Containers but the cat is out of the bag and we can't put
it back.
