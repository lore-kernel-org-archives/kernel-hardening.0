Reply-To: kernel-hardening@lists.openwall.com
References: <56FAA0CC.2050201@osg.samsung.com>
 <1459277167-9973-1-git-send-email-mic@digikod.net>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56FAD23D.1020205@osg.samsung.com>
Date: Tue, 29 Mar 2016 13:06:37 -0600
MIME-Version: 1.0
In-Reply-To: <1459277167-9973-1-git-send-email-mic@digikod.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH 1/2] selftest/seccomp: Fix the flag name
 SECCOMP_FILTER_FLAG_TSYNC
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>, linux-security-module@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Will Drewry <wad@chromium.org>, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com, Shuah Khan <shuahkh@osg.samsung.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/29/2016 12:46 PM, Mickaël Salaün wrote:
> Rename SECCOMP_FLAG_FILTER_TSYNC to SECCOMP_FILTER_FLAG_TSYNC to match
> the UAPI.
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Shuah Khan <shuahkh@osg.samsung.com>
> Cc: Will Drewry <wad@chromium.org>
> ---
>  tools/testing/selftests/seccomp/seccomp_bpf.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)

Thanks. Applied to linux-kselftest fixes for 4.6-rc2

-- Shuah
