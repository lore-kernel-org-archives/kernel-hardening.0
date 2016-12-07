Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <776ce31c-5268-8476-b6b1-989aa462327d@gmail.com>
References: <776ce31c-5268-8476-b6b1-989aa462327d@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 7 Dec 2016 14:08:40 -0800
Message-ID: <CAGXu5jLvFbfjYUuZnD0xK-9sgLbb-XPvTp1ieoTrMh_CNj0H-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Picking "Write a plugin to do format string
 warnings correctly"
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Dec 6, 2016 at 3:21 PM, Ruslan Kuprieiev <kupruser@gmail.com> wrote=
:
> Hi!
>
> After watching a bunch of talks from Kees about security, I've finally
> decided to try to participate in KSPP.

Hi and welcome!

> If it's not taken, I would like to start with this task:
>
>      Write a plugin to do format string warnings correctly (gcc's
> -Wformat-security is bad about const strings)
>
> Unfortunately, I wasn't able to find any details about this task. Could
> someone provide some info about it, please?

Sorry those TODOs items are so terse; they're mostly just brain dumps
so we don't lose things. :)

The problem with -Wformat-security in gcc is that it doesn't correctly
notice a bunch of const string cases. If you look at my
format-security branch:
http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=3Dformat-=
security

There's a commit at the top called "format-security: move static
strings to const", which illustrates the first kind of problem gcc
has, which is not realizing that "const char *var" is "const char
var[]":

- const char *name =3D "fbcon";
+ const char name[] =3D "fbcon";

This can be seen with:

int main(int argc, char * argv[])
{
    char cmd[80];
    const char *pointer =3D "pointer: %p\n";

    snprintf(cmd, sizeof(cmd), "cat /proc/%d/maps", getpid());
    system(cmd);

    printf(pointer, pointer);
    fflush(NULL);
    pointer[0] =3D 'P';

    return 0;
}

$ gcc -Wall -Wformat=3D2 -Wformat-security format-security.c -o format-secu=
rity
format-security.c: In function =E2=80=98main=E2=80=99:
format-security.c:22:5: warning: format not a string literal, argument
types not checked [-Wformat-nonliteral]
     printf(pointer, pointer);
     ^
format-security.c:24:16: error: assignment of read-only location =E2=80=98*=
pointer=E2=80=99
     pointer[0] =3D 'P';
                ^
And, this is right, if line 24 is removed, we can see the contents of
"pointer" are, as expected, in read-only memory:

$ ./format-security
55aa9d70b000-55aa9d70c000 r-xp 00000000 fd:06 28
  /tmp/format-security
55aa9d90b000-55aa9d90c000 r--p 00000000 fd:06 28
  /tmp/format-security
55aa9d90c000-55aa9d90d000 rw-p 00001000 fd:06 28
  /tmp/format-security
...
pointer: 0x55aa9d70b984

The reason gcc DOES warn about "const char *pointer" is because the
value of pointer itself can change. Building with "const char * const
pointer" tells gcc "pointer" should be read-only (though usually this
isn't enforced in variable placement). The goal would be to teach gcc
that if a variable is only ever assigned to read-only locations, it's
a false positive, so don't warn about it.

Here's an example from the kernel, in drivers/gpu/drm/ttm/ttm_memory.c:

static int ttm_mem_init_kernel_zone(struct ttm_mem_global *glob,
                                    const struct sysinfo *si)
{
        struct ttm_mem_zone *zone =3D kzalloc(sizeof(*zone), GFP_KERNEL);
...
        zone->name =3D "kernel";
...
        ret =3D kobject_init_and_add(
                &zone->kobj, &ttm_mem_zone_kobj_type, &glob->kobj, zone->na=
me);


zone->name is pointing to a read-only string. -Wformat-security yells
about this because it can't tell that ->name is never reassigned
between the first place and where it gets used as a format string.


-Kees

--=20
Kees Cook
Nexus Security
