Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 26 Aug 2013 18:20:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20130826172054.GE27005@ZenIV.linux.org.uk>
References: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>
 <871u5gqtw3.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u5gqtw3.fsf@xmission.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: [PATCH 1/2] procfs: restore 0400 permissions on
 /proc/*/{syscall,stack,personality}
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Djalal Harouni <tixxdz@opendz.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 26, 2013 at 09:49:48AM -0700, Eric W. Biederman wrote:

> How does changing the permissions to S_IRUSR prevent someone from
> opening the file before, and reading the file after a suid exec?
> 
> > This patch restores the old mode which was 0400
> 
> Which seems to add no security whatsoever and obscure the fact that
> anyone who cares can read the file so what is the point?

Two words: "security sclerosis".  Both patches NAKed, of course.
