MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170328234650.19695-3-mic@digikod.net>
References: <20170328234650.19695-1-mic@digikod.net> <20170328234650.19695-3-mic@digikod.net>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 18 Apr 2017 14:58:35 -0700
Message-ID: <CAGXu5jJQaxTOGgKCcApOiAX+ZnSgGQG6nU30hD0WeyQRcZ=zDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH net-next v6 02/11] bpf,landlock: Define an eBPF program
 type for Landlock
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Matthew Garrett <mjg59@srcf.ucam.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Will Drewry <wad@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Network Development <netdev@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 28, 2017 at 4:46 PM, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>=
 wrote:
> Add a new type of eBPF program used by Landlock rules.
>
> This new BPF program type will be registered with the Landlock LSM
> initialization.
>
> Add an initial Landlock Kconfig.
>
> Changes since v5:
> * rename file hooks.c to init.c
> * fix spelling
>
> Changes since v4:
> * merge a minimal (not enabled) LSM code and Kconfig in this commit
>
> Changes since v3:
> * split commit
> * revamp the landlock_context:
>   * add arch, syscall_nr and syscall_cmd (ioctl, fcntl=E2=80=A6) to be ab=
le to
>     cross-check action with the event type
>   * replace args array with dedicated fields to ease the addition of new
>     fields
>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: James Morris <james.l.morris@oracle.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Serge E. Hallyn <serge@hallyn.com>
> ---
> [...]
> +static inline bool bpf_landlock_is_valid_subtype(
> +               union bpf_prog_subtype *prog_subtype)
> +{
> +       if (WARN_ON(!prog_subtype))
> +               return false;
> +
> +       switch (prog_subtype->landlock_rule.event) {
> +       case LANDLOCK_SUBTYPE_EVENT_FS:
> +               break;
> +       case LANDLOCK_SUBTYPE_EVENT_UNSPEC:
> +       default:
> +               return false;
> +       }
> +
> +       if (!prog_subtype->landlock_rule.version ||
> +                       prog_subtype->landlock_rule.version > LANDLOCK_VE=
RSION)
> +               return false;
> +       if (!prog_subtype->landlock_rule.event ||
> +                       prog_subtype->landlock_rule.event > _LANDLOCK_SUB=
TYPE_EVENT_LAST)
> +               return false;
> +       if (prog_subtype->landlock_rule.ability & ~_LANDLOCK_SUBTYPE_ABIL=
ITY_MASK)
> +               return false;
> +       if (prog_subtype->landlock_rule.option & ~_LANDLOCK_SUBTYPE_OPTIO=
N_MASK)
> +               return false;
> +
> +       /* check ability flags */
> +       if (prog_subtype->landlock_rule.ability & LANDLOCK_SUBTYPE_ABILIT=
Y_WRITE &&
> +                       !capable(CAP_SYS_ADMIN))
> +               return false;
> +       if (prog_subtype->landlock_rule.ability & LANDLOCK_SUBTYPE_ABILIT=
Y_DEBUG &&
> +                       !capable(CAP_SYS_ADMIN))
> +               return false;
> +
> +       return true;
> +}

I would add more comments for the rule and ability tests just to help
people read this.

> +
> +static inline const struct bpf_func_proto *bpf_landlock_func_proto(
> +               enum bpf_func_id func_id, union bpf_prog_subtype *prog_su=
btype)
> +{
> +       bool event_fs =3D (prog_subtype->landlock_rule.event =3D=3D
> +                       LANDLOCK_SUBTYPE_EVENT_FS);
> +       bool ability_write =3D !!(prog_subtype->landlock_rule.ability &
> +                       LANDLOCK_SUBTYPE_ABILITY_WRITE);
> +       bool ability_debug =3D !!(prog_subtype->landlock_rule.ability &
> +                       LANDLOCK_SUBTYPE_ABILITY_DEBUG);
> +
> +       switch (func_id) {
> +       case BPF_FUNC_map_lookup_elem:
> +               return &bpf_map_lookup_elem_proto;
> +
> +       /* ability_write */
> +       case BPF_FUNC_map_delete_elem:
> +               if (ability_write)
> +                       return &bpf_map_delete_elem_proto;
> +               return NULL;
> +       case BPF_FUNC_map_update_elem:
> +               if (ability_write)
> +                       return &bpf_map_update_elem_proto;
> +               return NULL;
> +
> +       /* ability_debug */
> +       case BPF_FUNC_get_current_comm:
> +               if (ability_debug)
> +                       return &bpf_get_current_comm_proto;
> +               return NULL;
> +       case BPF_FUNC_get_current_pid_tgid:
> +               if (ability_debug)
> +                       return &bpf_get_current_pid_tgid_proto;
> +               return NULL;
> +       case BPF_FUNC_get_current_uid_gid:
> +               if (ability_debug)
> +                       return &bpf_get_current_uid_gid_proto;
> +               return NULL;
> +       case BPF_FUNC_trace_printk:
> +               if (ability_debug)
> +                       return bpf_get_trace_printk_proto();
> +               return NULL;
> +
> +       default:
> +               return NULL;
> +       }
> +}

I find this switch statement mixed with the "if (ability...)" kind of
hard to read and a bit fragile. I think it'd be better written as:

switch (func_id) {
case BPF_FUNC_map_lookup_elem:
   return ...
}

if (ability_write) {
    switch (func_id) {
        ...
    }
}

if (ability_debug) {
    switch (func_id) {
        ...
    }
}

return NULL;

Then it's self-documenting and it's harder to add a case without the
desired ability check...

> +static const struct bpf_verifier_ops bpf_landlock_ops =3D {
> +       .get_func_proto =3D bpf_landlock_func_proto,
> +       .is_valid_access =3D bpf_landlock_is_valid_access,
> +       .is_valid_subtype =3D bpf_landlock_is_valid_subtype,
> +};
> +
> +static struct bpf_prog_type_list bpf_landlock_type __ro_after_init =3D {
> +       .ops =3D &bpf_landlock_ops,
> +       .type =3D BPF_PROG_TYPE_LANDLOCK,
> +};

Yay const and ro_after_init! :)

-Kees

--=20
Kees Cook
Pixel Security
