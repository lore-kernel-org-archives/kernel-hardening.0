Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 20 Feb 2012 09:22:23 +0100
From: Ingo Molnar <mingo@elte.hu>
Message-ID: <20120220082223.GF30810@elte.hu>
References: <20120218193857.GA30985@www.outflux.net>
 <20120219124916.GB25900@elte.hu>
 <CAGXu5jL-NZP9At16q-b6biszMAWQQ4HLzW3cHDQUf0m7PGwGbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5jL-NZP9At16q-b6biszMAWQQ4HLzW3cHDQUf0m7PGwGbQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] fs: hardlink creation restrictions
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> >> +#ifdef CONFIG_AUDIT
> >> +     if (error) {
> >> +             struct audit_buffer *ab;
> >> +
> >> +             ab = audit_log_start(current->audit_context,
> >> +                                  GFP_KERNEL, AUDIT_AVC);
> >> +             audit_log_format(ab, "op=linkat action=denied");
> >> +             audit_log_format(ab, " pid=%d comm=", current->pid);
> >> +             audit_log_untrustedstring(ab, current->comm);
> >> +             audit_log_d_path(ab, " path=", old_path);
> >> +             audit_log_format(ab, " dev=");
> >> +             audit_log_untrustedstring(ab, inode->i_sb->s_id);
> >> +             audit_log_format(ab, " ino=%lu", inode->i_ino);
> >> +             audit_log_end(ab);
> >> +     }
> >> +#endif
> >
> > Small detail: don't these audit methods map to nothing on
> > !CONFIG_AUDIT, allowing the #ifdef to be dropped? (if not then
> > it should really be so.)
> 
> Ah-ha; a more careful look at audit.h agrees. :) I'll adjust 
> this as well.

Another detail, I'd also stick those logging lines into a 
separate inline function right before the linkat function, so 
that the logging details do not obscure the main flow of VFS 
logic:

	if (error)
		audit_log_linkat_denied(current, old_path, inode);

... or so. People reading this function won't be interested in 
the logging details 99.9% of the time.

Thanks,

	Ingo
