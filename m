MIME-Version: 1.0
In-Reply-To: <1dccd8da-c96f-3947-d90f-a3f3d4f389fd@schaufler-ca.com>
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
 <1497286620-15027-6-git-send-email-s.mesoraca16@gmail.com> <1dccd8da-c96f-3947-d90f-a3f3d4f389fd@schaufler-ca.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 13 Jun 2017 09:55:30 +0200
Message-ID: <CAJHCu1LdGEEFkpAZqVYYORfXxTA+VuHUv2Pv+rYMN1Nt4KGVBg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 05/11] Creation of "check_vmflags" LSM hook
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, linux-mm@kvack.org
List-ID: <kernel-hardening.lists.openwall.com>

2017-06-12 23:31 GMT+02:00 Casey Schaufler <casey@schaufler-ca.com>:
> Have the hook return a value and return that rather
> than -EPERM. That way a security module can choose an
> error that it determines is appropriate. It is possible
> that a module might want to deny the access for a reason
> other than lack of privilege.
> [...]
>
> Same here
>
> [...]
>
> And here.

Yes, I think you are right. I'll fix it in the next version.
Thank you very much for taking the time to review my patch.
