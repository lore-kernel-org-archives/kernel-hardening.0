References: <20170529213800.29438-1-matt@nmatt.com>
 <20170529213800.29438-3-matt@nmatt.com>
 <20170529232640.16211960@alans-desktop>
 <CAFUG7CdDd0Yfegb1S6_wNQzje4EuLE0jPdvOE=uSQL152meyjQ@mail.gmail.com>
 <alpine.LRH.2.20.1705311239420.6920@namei.org>
From: Matt Brown <matt@nmatt.com>
Message-ID: <cb0daac8-bd8d-0780-cf04-46033f8fea10@nmatt.com>
Date: Wed, 31 May 2017 00:10:17 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.20.1705311239420.6920@namei.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: James Morris <jmorris@namei.org>, Boris Lukashev <blukashev@sempervictus.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 05/30/2017 10:48 PM, James Morris wrote:
> On Mon, 29 May 2017, Boris Lukashev wrote:
>
>> With all due respect sir, i believe your review falls short of the
>> purpose of this effort - to harden the kernel against flaws in
>> userspace.
>
> Which effort?  Kernel self protection is about protecting against flaws in
> the kernel.
>
> See:
> https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project
>
>   "This project starts with the premise that kernel bugs have a very long
>    lifetime, and that the kernel must be designed in ways to protect against
>    these flaws."
>
> We need to avoid conflating:
>
> - hardening the kernel against attack; and
> - modifying the kernel to try and harden userspace.
>
> These patches are the latter, and the case for them is not as
> straightforward.
>
>
> - James
>

I agree that these patches aren't kernel self protection and I don't
believe I have claimed they are such a thing. These patches I'm
presenting are more akin to ptrace protections that are found in Yama.
