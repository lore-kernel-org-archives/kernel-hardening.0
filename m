Subject: Re: VLA commit log
References: <20180312052639.GE8631@eros>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <861efe7a-e51f-e004-5979-aef0ed9ff1fe@embeddedor.com>
Date: Mon, 12 Mar 2018 00:38:04 -0500
MIME-Version: 1.0
In-Reply-To: <20180312052639.GE8631@eros>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: "Tobin C. Harding" <tobin@apporbit.com>, Kees Cook <keescook@chromium.org>, Tycho Andersen <tycho@tycho.ws>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 03/12/2018 12:26 AM, Tobin C. Harding wrote:
> Hi,
> 
> I got some push back on the commit log we have all started to use
> (copying Kees' initial commit log).  If we are going to do hundreds of
> these patches should we write a perfectly correct commit log that can be
> included as the start of the 'why' of each VLA removal patch?  Here is
> my attempt, I am quite bad at writing commit logs so would love someone
> to fix it up.
> 

The same thing happened to me once and then I wrote this:

In preparation to enabling -Wvla, remove VLA and replace it
with a fixed-length array instead.

 From a security viewpoint, the use of Variable Length Arrays can be
a vector for stack overflow attacks. Also, in general, as the code
evolves it is easy to lose track of how big a VLA can get. Thus, we
can end up having segfaults that are hard to debug.

Also, fixed as part of the directive to remove all VLAs from
the kernel: https://lkml.org/lkml/2018/3/7/621

The maintainer lived happily ever after. :)

--
Gustavo

>      Kernel stack size is limited.  Variable Length Arrays (VLA) open the
>      kernel up to stack abuse in a couple of ways;
>      
>      1. If the variable can be controlled by an attacker.
>      2. Not having the size of the stack right there in plain site makes it
>      harder to maintain the code base because changes in one place can effect
>      the stack in another place (i.e in another function).
>      
>      It would be nice to be able to build the kernel with -Wvla.  There has
>      been some consensus on this already [1].
> 
>      ...
> 
>      [1]: https://lkml.org/lkml/2018/3/7/621
> 
> The '...' would of course be different for each patch.  In case you
> missed it here is the catalyst for this email
> 
> 	On Mon, Mar 12, 2018 at 03:49:40PM +1100, Tobin C. Harding wrote:
> 	> The kernel would like to have all stack VLA usage removed[1].
> 
> 	Can you please stop writing this?  The Linux kernel isn't
> 	sentient; it doesn't "like" anything.  You need to explain why
> 	*you* (and other people) believe these changes should be made.
> 
> 
> Perhaps we should add a summary of all the gcc discussion i.e why const
> variables still cause gcc to emit a VLA warning.
> 
> 
> thanks,
> Tobin.
> 
