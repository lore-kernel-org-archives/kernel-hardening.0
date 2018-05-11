Subject: Re: [PATCH v5 5/7] proc: instantiate only pids that we can ptrace on
 'limit_pids=1' mount option
References: <20180511093613.GA1330@comp-core-i7-2640m-0182e6>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <7c638a92-8c40-fa15-8c63-777232588137@infradead.org>
Date: Fri, 11 May 2018 09:09:04 -0700
MIME-Version: 1.0
In-Reply-To: <20180511093613.GA1330@comp-core-i7-2640m-0182e6>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Alexey Gladkov <gladkov.alexey@gmail.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, aniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, bfields@fieldses.org, Stephen Rothwell <sfr@canb.auug.org.au>, solar@openwall.com, "Dmitry V. Levin" <ldv@altlinux.org>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 05/11/2018 02:36 AM, Alexey Gladkov wrote:
> From: Djalal Harouni <tixxdz@gmail.com>
> 
> If "limit_pids=1" mount option is set then do not instantiate pids that
> we can not ptrace. "limit_pids=1" means that procfs should only contain
> pids that the caller can ptrace.

Where can I find documentation on these mount options (pidonly, limit_pids)?

Thanks.

> Cc: Kees Cook <keescook@chromium.org>
> Cc: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
> ---
>  fs/proc/base.c | 9 +++++++++
>  1 file changed, 9 insertions(+)


-- 
~Randy
