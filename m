Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 8 Nov 2011 15:07:35 -0500
From: Ted Ts'o <tytso@mit.edu>
Message-ID: <20111108200735.GM24234@thunk.org>
References: <4EB83674.3040207@zytor.com>
 <20111107201120.GA5775@albatros>
 <4EB843FF.5080201@zytor.com>
 <CA+55aFwYGivYFZTLprSB+oDm3E4MG0s3PEQabs166v6YRL5u-Q@mail.gmail.com>
 <4EB84F05.1000704@zytor.com>
 <CA+55aFxFNaRuTx-0vx+RhrkavrcNDiDh5jxcRyWPy8-QZHGD9A@mail.gmail.com>
 <20111107232132.2c6880a5@lxorguk.ukuu.org.uk>
 <20111107232750.GA4854@kroah.com>
 <4BA97845-BA47-47F3-A923-9B24AB7306E9@mit.edu>
 <20111107234546.GA5835@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107234546.GA5835@kroah.com>
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to
 /proc/interrupts
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Vasiliy Kulikov <segoon@openwall.com>, Eric Paris <eparis@parisplace.org>, kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 07, 2011 at 03:45:46PM -0800, Greg KH wrote:
> > As I mentioned at the kernel summit, I'd like revoke along with a
> > formal notification from block devices that get ejected to the file
> > system layer, and the file system should be able to call a VFS library
> > function which revokes all open file descriptor on the ejected block
> > device.  It would result in much cleaner handling at the file system
> > level when a USB storage device gets pulled.
> 
> So you want revoke() on a block device to do what?  The same thing as
> disconnecting it from the hardware level?

No, what I meant is that a disconnect at the hardware level should
lead to notification to the file system via a call to struct super
operations function.  And then the file system can use that callback
(call it super->s_ops->device_ejected) to call revoke on all of the
open files on the file system.

If we were to implement a revoke(2) system call (as opposed to just
VFS functionality callable from kernel code), it should probably do
what revoke(2) does on other Unix systems:

     The revoke() system call invalidates all current open file
     descriptors in the system for the file named by path.  Subsequent
     operations on any such descriptors fail, with the exceptions that
     a read() from a character device file which has been revoked
     returns a count of zero (end of file), and a close() system call
     will succeed.  If the file is a special file for a device which
     is open, the device close function is called as if all open
     references to the file had been closed.

     Access to a file may be revoked only by its owner or the super
     user.  The revoke() system call is currently supported only for
     block and character special device files.  It is normally used to
     prepare a terminal device for a new login session, preventing any
     access by a previous user of the terminal.

The revoke functionality I was talking about is a way to disconnect a
file descriptor from the mounted file system, since when the device
that backed it has disappeared, the file system should disappear as
well.  What should be left are file descriptors that return an error
when read or written, and which are administratively managed by the
VFS layer, with all of the file system's refcounts appropriate
decremented, such that if it were loaded as a module, the fs module
could be safely unloaded.  

      	 					- Ted
