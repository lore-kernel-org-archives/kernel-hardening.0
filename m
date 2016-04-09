Reply-To: kernel-hardening@lists.openwall.com
References: <1460138602-85386-1-git-send-email-thgarnie@google.com>
From: lazytyped <lazytyped@gmail.com>
Message-ID: <57090CDE.6080509@gmail.com>
Date: Sat, 9 Apr 2016 07:08:30 -0700
MIME-Version: 1.0
In-Reply-To: <1460138602-85386-1-git-send-email-thgarnie@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC v2] mm: SLAB freelist randomization
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 4/8/16 11:03 AM, Thomas Garnier wrote:
> For example this attack against SLUB (also applicable against SLAB)
> would be affected:
> https://jon.oberheide.org/blog/2010/09/10/linux-kernel-can-slub-overflow/

would it?

- allocate a ton of shmid_kernel until you get a fresh page
- free one of such objects (here is where your randomization comes into
play)
- allocate the "vulnerable" object
- trigger the overflow
- start "freeing" the others - one will work

This doesn't work only in the case in which you are the last object in
the SLUB. So what you are achieving is a 1/(pagesize/sizeof_objects)
chance of making the attack less reliable. But I can free yet another
object and retry, if the previous overflow didn't kill me (simplest way
to guarantee that is to not completely fill the newly allocated SLUB page).


       -   twiz
