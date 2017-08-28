Date: Mon, 28 Aug 2017 13:46:37 +1000 (AEST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <20170823024452.zvizovwfd7xjucsx@ast-mbp>
Message-ID: <alpine.LRH.2.20.1708281345280.8842@namei.org>
References: <20170821000933.13024-1-mic@digikod.net> <20170821000933.13024-3-mic@digikod.net> <20170823024452.zvizovwfd7xjucsx@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH net-next v7 02/10] bpf: Add eBPF program subtype and
 is_valid_subtype() verifier
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Matthew Garrett <mjg59@srcf.ucam.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Will Drewry <wad@chromium.org>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, netdev@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 22 Aug 2017, Alexei Starovoitov wrote:

> more general question: what is the status of security/ bits?
> I'm assuming they still need to be reviewed and explicitly acked by James, right?

Yep, along with other core security developers where possible.


-- 
James Morris
<jmorris@namei.org>
