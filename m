Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 26 Sep 2013 03:42:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20130926024234.GE13318@ZenIV.linux.org.uk>
References: <1380140085-29712-1-git-send-email-tixxdz@opendz.org>
 <1380140085-29712-5-git-send-email-tixxdz@opendz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380140085-29712-5-git-send-email-tixxdz@opendz.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: [PATCH 04/12] seq_file: Make seq_file able to access the file's
 opener cred
To: Djalal Harouni <tixxdz@opendz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com, tixxdz@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Sep 25, 2013 at 09:14:37PM +0100, Djalal Harouni wrote:
> The f_cred field of the file struct contains the cred of current at
> open time. This field can be used to get the context of open, and track
> current's cred changes after.
> 
> The procfs is one of those fs that need to track current cred changes
> in order to implement proper permission checks on each system call.
> 
> The procfs make use of seq_file struct and its iterators to step through
> /proc objects. These iterators and seq_file helpers must be able to
> access the file->f_cred to perform various permission checks at any
> time.
> 
> Therefor add the f_cred field to the seq_file struct and a helper
> seq_f_cred() to return it.

NAK.  This is completely irrelevant for most of seq_file users and it simply
does not belong in struct seq_file.
