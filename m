Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 3 May 2016 08:19:34 +1000 (AEST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <CAGXu5jK1U12vMk11HD_x_gNz3Rk4ZgEfdThY7DHvm4e4sPRh4g@mail.gmail.com>
Message-ID: <alpine.LRH.2.20.1605030816180.21933@namei.org>
References: <1458784008-16277-1-git-send-email-mic@digikod.net> <CAGXu5jK1U12vMk11HD_x_gNz3Rk4ZgEfdThY7DHvm4e4sPRh4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [RFC v1 00/17] seccomp-object: From attack surface reduction to
 sandboxing
To: Kees Cook <keescook@chromium.org>
Cc: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, linux-security-module <linux-security-module@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Will Drewry <wad@chromium.org>, Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 27 Apr 2016, Kees Cook wrote:

> Doing "b" means writing a policy engine. I would expect it to look a
> lot like either AppArmor or TOMOYO. TOMOYO has network structure
> processing, so probably it would look more like TOMOYO if you wanted
> more than just file paths. Maybe a seccomp LSM could share logic from
> one of the existing path-based LSMs.

Right, and that LSM should probably be AppArmor, which is actually being 
used and maintained.


-- 
James Morris
<jmorris@namei.org>
