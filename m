Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4EE05A87.1050904@kingswood-consulting.co.uk>
Date: Thu, 08 Dec 2011 14:34:47 +0800
From: Frank Kingswood <frank@kingswood-consulting.co.uk>
MIME-Version: 1.0
References: <20111206235815.GA21764@www.outflux.net> <CA+55aFzRz6DcmP8uYaeYAUkpBfePZTYQg-hvERnA9huCQu4X3g@mail.gmail.com>
In-Reply-To: <CA+55aFzRz6DcmP8uYaeYAUkpBfePZTYQg-hvERnA9huCQu4X3g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2011.1] fs: symlink restrictions on sticky directories
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Dan Rosenberg <drosenberg@vsecurity.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 08/12/11 02:41, Linus Torvalds wrote:
> On Tue, Dec 6, 2011 at 3:58 PM, Kees Cook<keescook@chromium.org>  wrote:
>> A long-standing class of security issues is the symlink-based
>> time-of-check-time-of-use race, most commonly seen in world-writable
>> directories like /tmp.
>
> Ugh. I really dislike the implementation.
>
> Wouldn't it be much nicer to instead actually use the symlink
> protection fields, and make the rules be:
>
>   - creating a symlink as root does the traditional "lrwxrwxrwx" thing
>   - creating a symlink in a directory you own similarly does "lrwxrwxrwx"
>   - creating a symlink anywhere else (which implies either sticky or
> world-writable directory) does "lrwx------", so only you can use it.
>
> That seems to be much nicer semantics, and makes the protection
> *visible* instead of some kind of hacky run-time random behavior
> depending on some invisible config option that people aren't even
> aware of.

This sounds really good way to go about it, but it seems that an 
implementation might be invasive.

Currently the symlinks are created in the file system e.g. ext4_symlink 
has the S_IFLNK|S_IRWXUGO buried in it. It is likely other fs's follow 
this model too.

Also, having tried creating such a link, it seems that the read-side 
permissions check (at least in generic_readlink) is missing.

Frank
-- 
------------------------------------------------------------------------
Frank A. Kingswood                      frank@kingswood-consulting.co.uk
Cambridge, United Kingdom                               +44-7545-209 100
