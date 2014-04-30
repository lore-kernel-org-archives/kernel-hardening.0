Reply-To: kernel-hardening@lists.openwall.com
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Date: Wed, 30 Apr 2014 21:49:23 +0200
Message-ID: <1507574.Y0KFKOdI6F@vostro.rjw.lan>
In-Reply-To: <20140430150844.GA10621@mwanda>
References: <20140430150844.GA10621@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Subject: [kernel-hardening] Re: [patch] lib: check for strcpy() overflows to fixed length buffers
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wednesday, April 30, 2014 06:08:44 PM Dan Carpenter wrote:
> There are sometimes where we know that we are doing an strcpy() into a
> fixed length buffer.  In those cases, we could verify that the strcpy()
> doesn't overflow.  This patch introduces DEBUG_STRICT_SLOW_STRCPY_CHECKS
> if you want to check for that.  The downside is that it makes strcpy
> slower.
> 
> I introduced __compiletime_size() to make this work.  It returns the
> size of the destination buffer or zero if the size isn't known.  The
> __compiletime_object_size() is similar but if you pass it a struct
> member then it returns the size of everything from there to the end of
> the struct.  Another difference is __compiletime_object_size() returns
> -1 for unknown sizes.
> 
> If you pass a char pointer to __compiletime_size() then it returns zero.
> 
> The strcpy() check ignores buffers with just one byte because people
> often use those for variable length strings at the end of a struct.
> 
> I have tested this patch lightly and created some bugs for it to detect
> but I have not detected any real life overflows.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/include/acpi/platform/acenv.h b/include/acpi/platform/acenv.h
> index e863dd5..5e0fc2b 100644
> --- a/include/acpi/platform/acenv.h
> +++ b/include/acpi/platform/acenv.h

This is an ACPICA header and changes to it need to be submitted to the ACPICA
maintainers (as per MAINTAINERS).  We only get ACPICA changes from the
upstream project (except for really special situations).

> @@ -320,7 +320,7 @@
>  #define ACPI_STRSTR(s1,s2)      strstr((s1), (s2))
>  #define ACPI_STRCHR(s1,c)       strchr((s1), (c))
>  #define ACPI_STRLEN(s)          (acpi_size) strlen((s))
> -#define ACPI_STRCPY(d,s)        (void) strcpy((d), (s))
> +#define ACPI_STRCPY(d,s)        strcpy((d), (s))
>  #define ACPI_STRNCPY(d,s,n)     (void) strncpy((d), (s), (acpi_size)(n))
>  #define ACPI_STRNCMP(d,s,n)     strncmp((d), (s), (acpi_size)(n))
>  #define ACPI_STRCMP(d,s)        strcmp((d), (s))

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
