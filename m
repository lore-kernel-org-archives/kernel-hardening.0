From: =?iso-2022-jp?B?GyRCQ2ZCPE06MGwbKEIgLyBOQUtBTVVSQRskQiEkGyhCWVVVSUNISQ==?=
	<yuichi.nakamura.fe@hitachi.com>
Date: Fri, 22 Sep 2017 02:49:59 +0000
Message-ID: <D6DDBEC5E2802849A9493717C9A419C3E5343C1C@GSjpTK1DCembx17.service.hitachi.net>
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] [RFC] A method to prevent priviledge escalation 
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: "yamauchi@cs.okayama-u.ac.jp" <yamauchi@cs.okayama-u.ac.jp>
List-ID: <kernel-hardening.lists.openwall.com>

Hi.

As we said in Linux Security Summit 2017,=20
we would like to post a patch to prevent privilege escalation attack.

The concept is here:
http://events.linuxfoundation.org/sites/events/files/slides/nakamura_201708=
31_1.pdf

This work is still work in progress and feedback is welcomed.
Below patch works for linux-4.4.0,=20
To see that it works (try it in a safe place!),=20
 * build vulnerable kernel on Ubuntu 16.04.1=20
   source: https://launchpad.net/ubuntu/+source/linux/4.4.0-62.83
   please enable "CONFIG_AKO" in kernel config.
 * try a poc code for kernel vulnerability
   https://github.com/xairy/kernel-exploits/blob/master/CVE-2017-6074/poc.c
 * look at kernel log, you can see a log that it detected attack like below=
:
 AKO: detected unauthorized change of UID. syscall=3D45 original: uid=3D100=
0, euid=3D1000, fsuid=3D1000, suid=3D1000 attempt: uid=3D0, euid=3D0, fsuid=
=3D0, suid=3D0
 AKO: detected unauthorized change of gid. syscall=3D45 original: gid=3D100=
0, egid=3D1000, fsgid=3D1000, sgid=3D1000 attempt: gid=3D0, egid=3D0, fsgid=
=3D0, sgid=3D0

Regards,
Yuichi Nakamura, Hitachi,Ltd.
Toshihiro Yamauchi, Okayama University

--- linux-4.4.0-62-83.orig/arch/x86/kernel/ako.c	1970-01-01 09:00:00.000000=
000 +0900
+++ linux-4.4.0/arch/x86/kernel/ako.c	2017-07-02 17:43:15.780000000 +0900
@@ -0,0 +1,55 @@
+/*
+ * Additional Kernel Observer (AKO)
+ *   CPU specific part
+ * Copyright 2017 Okayama-University
+ *     Yohei Akao, Yamauchi Laboratory
+ * Copyright 2017 Hitachi,Ltd.
+ *     Yuichi Nakamura
+ */
+
+#include <linux/cred.h>
+#include <linux/printk.h>
+#include <linux/ako.h>
+
+asmlinkage void AKO_before(struct ako_struct * ako_cred, unsigned long lon=
g ako_sysnum)
+{
+        /* Called at the entry of system calls,
+           credential data are saved to detect priviledge escalation attac=
ks
+           that exploit vulnerabilites of system calls.
+        */
+
+       /*save system call number*/
+        ako_cred->ako_sysnum =3D ako_sysnum;
+
+	/*System calls that change credential are skipped*/=09
+	if(!AKO_syscall_checked(ako_sysnum))
+		return;
+
+	/*credential data are saved*/
+        AKO_save_creds(ako_cred,ako_sysnum);
+	/*addr_limit is saved*/
+	ako_cred->ako_addr_limit =3D current_thread_info()->addr_limit.seg;
+
+}
+
+
+asmlinkage void AKO_after(struct ako_struct * ako_cred)
+{
+	/*System calls that change credential are skipped*/=09
+	if(!AKO_syscall_checked(ako_cred->ako_sysnum))
+		return;
+
+	/*check addr_limit, restore if changed*/
+/*        if(current_thread_info()->addr_limit.seg !=3D ako_cred->ako_addr=
_limit){
+		audit_AKO_rlimit(ako_cred, current_thread_info()->addr_limit.seg);=20
+                current_thread_info()->addr_limit.seg =3D ako_cred->ako_ad=
dr_limit;
+		audit_AKO_restore(ako_cred, "addr_limit");
+                return ;
+        } */
+
+	/*check credentials, and restore if changed*/
+        AKO_check_creds(ako_cred);
+
+        return;
+}
+
--- linux-4.4.0-62-83.orig/kernel/ako.c	1970-01-01 09:00:00.000000000 +0900
+++ linux-4.4.0/kernel/ako.c	2017-07-03 23:06:54.068000000 +0900
@@ -0,0 +1,389 @@
+/*
+ * Additional Kernel Observer (AKO)
+ *  Common features
+ * Copyright 2017 Okayama-University
+ *     Yohei Akao, Yamauchi Laboratory
+ * Copyright 2017 Hitachi,Ltd.
+ *     Yuichi Nakamura
+ */
+
+#include <linux/printk.h>
+#include <linux/cred.h>
+#include <linux/syscalls.h>
+#include <linux/ako.h>
+
+#include <linux/audit.h>
+#include <uapi/linux/audit.h>
+#include "audit.h"
+
+void audit_AKO_rlimit(struct ako_struct * ako_cred, unsigned long current_=
addr_limit) {
+	/*This is called from arch/xx/ako.c*/
+	struct audit_buffer *ab;
+
+	printk(KERN_INFO "AKO: detected unauthorized change of addr_limit: syscal=
l=3D%u original: 0x%lx, attempt: 0x%lx", ako_cred->ako_sysnum, ako_cred->ak=
o_addr_limit,current_addr_limit);
+        if(!audit_enabled) {
+                return;
+        }
+	ab =3D audit_log_start(NULL, GFP_KERNEL, AUDIT_SYSCALL);
+	if (unlikely(!ab))
+		return;
+
+	audit_log_format(ab, "AKO: detected unauthorized change of addr_limit: sy=
scall=3D%u original: 0x%lx, attempt: 0x%lx", ako_cred->ako_sysnum, ako_cred=
->ako_addr_limit,current_addr_limit);
+        audit_log_d_path_exe(ab, current->mm);
+        audit_log_end(ab);
+	return;=20
+}
+
+void audit_AKO_restore(struct ako_struct * ako_cred, const char * cred_typ=
e)
+{
+	struct audit_buffer *ab;
+=09
+	printk(KERN_INFO "AKO: restored credential:%s syscall=3D%u", cred_type, a=
ko_cred->ako_sysnum);
+	if(!audit_enabled) {
+		return;
+	}
+	ab =3D audit_log_start(NULL, GFP_KERNEL, AUDIT_SYSCALL);
+        if (unlikely(!ab))
+                return;
+
+	audit_log_format(ab, "AKO: restored credential:%s syscall=3D%u", cred_typ=
e,
+	ako_cred->ako_sysnum);
+=09
+	audit_log_d_path_exe(ab, current->mm);
+ 	audit_log_end(ab);
+}
+
+static void audit_AKO_uid(struct ako_struct * ako_cred)
+{
+        struct audit_buffer *ab;
+        const struct cred *ccred;
+        ccred =3D current->cred;
+
+	printk(KERN_INFO "AKO: detected unauthorized change of UID. syscall=3D%u =
original: uid=3D%u, euid=3D%u, fsuid=3D%u, suid=3D%u attempt: uid=3D%u, eui=
d=3D%u, fsuid=3D%u, suid=3D%u", ako_cred->ako_sysnum,=20
+	ako_cred->ako_uid, ako_cred->ako_euid, ako_cred->ako_fsuid, ako_cred->ako=
_suid,=20
+	ccred->uid.val, ccred->euid.val, current_fsuid().val, ccred->suid.val);
+
+	if(!audit_enabled) {
+ 		return;
+	}
+
+	ab =3D audit_log_start(NULL, GFP_KERNEL, AUDIT_SYSCALL);
+	if (unlikely(!ab))
+		return;
+	audit_log_format(ab, "AKO: detected unauthorized change of UID. syscall=
=3D%u original: uid=3D%u, euid=3D%u, fsuid=3D%u, suid=3D%u attempt: uid=3D%=
u, euid=3D%u, fsuid=3D%u, suid=3D%u", ako_cred->ako_sysnum,
+	ako_cred->ako_uid, ako_cred->ako_euid, ako_cred->ako_fsuid, ako_cred->ako=
_suid,
+	ccred->uid.val, ccred->euid.val, ccred->fsuid.val, ccred->suid.val);
+
+        audit_log_d_path_exe(ab, current->mm);
+        audit_log_end(ab);
+
+        return;
+}
+
+static void audit_AKO_gid(struct ako_struct * ako_cred)
+{
+        struct audit_buffer *ab;
+        const struct cred *ccred;
+        ccred =3D current->cred;
+
+        printk(KERN_INFO "AKO: detected unauthorized change of gid. syscal=
l=3D%u original: gid=3D%u, egid=3D%u, fsgid=3D%u, sgid=3D%u attempt: gid=3D=
%u, egid=3D%u, fsgid=3D%u, sgid=3D%u", ako_cred->ako_sysnum,
+        ako_cred->ako_gid, ako_cred->ako_egid, ako_cred->ako_fsgid, ako_cr=
ed->ako_sgid,
+        ccred->gid.val, ccred->egid.val, ccred->fsgid.val, ccred->sgid.val=
);
+
+        if(!audit_enabled) {
+                return;
+        }
+
+        ab =3D audit_log_start(NULL, GFP_KERNEL, AUDIT_SYSCALL);
+        if (unlikely(!ab))
+                return;
+        audit_log_format(ab, "AKO: detected unauthorized change of gid. sy=
scall=3D%u original: gid=3D%u, egid=3D%u, fsgid=3D%u, sgid=3D%u attempt: gi=
d=3D%u, egid=3D%u, fsgid=3D%u, sgid=3D%u", ako_cred->ako_sysnum,
+        ako_cred->ako_gid, ako_cred->ako_egid, ako_cred->ako_fsgid, ako_cr=
ed->ako_sgid,
+        ccred->gid.val, ccred->egid.val, ccred->fsgid.val, ccred->sgid.val=
);
+
+        audit_log_d_path_exe(ab, current->mm);
+        audit_log_end(ab);
+
+        return;
+}
+
+static void audit_AKO_cap(struct ako_struct * ako_cred)
+{
+	struct audit_buffer *ab;
+	const struct cred *ccred;
+	ccred =3D current->cred;
+
+	 printk(KERN_INFO "AKO: detected unauthorized change of capability. sysca=
ll=3D%u original: inh[0]=3D%u inh[1]=3D%u per[0]=3D%u per[1]=3D%u eff[0]=3D=
%u eff[1]%u bset[0]=3D%u bset[1]=3D%u attempt: inh[0]=3D%u inh[1]=3D%u per[=
0]=3D%u per[1]=3D%u eff[0]=3D%u eff[1]%u bset[0]=3D%u bset[1]=3D%u",
+	ako_cred->ako_sysnum,
+	ako_cred->ako_inheritable[0], ako_cred->ako_inheritable[1],
+	ako_cred->ako_permitted[0], ako_cred->ako_permitted[1],
+	ako_cred->ako_effective[0], ako_cred->ako_effective[1],
+       	ako_cred->ako_bset[0], ako_cred->ako_bset[1],
+	ccred->cap_inheritable.cap[0], ccred->cap_inheritable.cap[1],
+	ccred->cap_permitted.cap[0], ccred->cap_permitted.cap[1],
+	ccred->cap_effective.cap[0], ccred->cap_effective.cap[1],
+	ccred->cap_bset.cap[0], ccred->cap_bset.cap[1]);
+
+	if (!audit_enabled)
+		return;
+	ab =3D audit_log_start(NULL, GFP_KERNEL, AUDIT_SYSCALL);
+	if (unlikely(!ab))
+		return;
+
+	audit_log_format(ab, "AKO: detected unauthorized change of capability. sy=
scall=3D%u original: inh[0]=3D%u inh[1]=3D%u per[0]=3D%u per[1]=3D%u eff[0]=
=3D%u eff[1]%u bset[0]=3D%u bset[1]=3D%u attempt: inh[0]=3D%u inh[1]=3D%u p=
er[0]=3D%u per[1]=3D%u eff[0]=3D%u eff[1]%u bset[0]=3D%u bset[1]=3D%u",=20
+	ako_cred->ako_sysnum,=20
+	ako_cred->ako_inheritable[0], ako_cred->ako_inheritable[1],
+	ako_cred->ako_permitted[0], ako_cred->ako_permitted[1],=20
+ 	ako_cred->ako_effective[0], ako_cred->ako_effective[1],
+ 	ako_cred->ako_bset[0], ako_cred->ako_bset[1],
+	ccred->cap_inheritable.cap[0], ccred->cap_inheritable.cap[1],
+	ccred->cap_permitted.cap[0], ccred->cap_permitted.cap[1],
+	ccred->cap_effective.cap[0], ccred->cap_effective.cap[1],
+	ccred->cap_bset.cap[0], ccred->cap_bset.cap[1]);
+
+	audit_log_d_path_exe(ab, current->mm);
+	audit_log_end(ab);
+
+	return;
+}
+
+
+
+void AKO_save_creds(struct ako_struct * ako_cred, int ako_sysnum)
+{
+
+        /*Save credential information to be observed */
+        /*UID and GID*/
+        ako_cred->ako_uid =3D current->cred->uid.val;
+        ako_cred->ako_euid =3D current->cred->euid.val;
+        ako_cred->ako_fsuid =3D current->cred->fsuid.val;
+        ako_cred->ako_suid =3D current->cred->suid.val;
+        ako_cred->ako_gid =3D current->cred->gid.val;
+        ako_cred->ako_egid =3D current->cred->egid.val;
+        ako_cred->ako_fsgid =3D current->cred->fsgid.val;
+        ako_cred->ako_sgid =3D current->cred->sgid.val;
+        /*Capability*/
+        ako_cred->ako_inheritable[0] =3D current->cred->cap_inheritable.ca=
p[0];
+        ako_cred->ako_inheritable[1] =3D current->cred->cap_inheritable.ca=
p[1];
+        ako_cred->ako_permitted[0] =3D current->cred->cap_permitted.cap[0]=
;
+        ako_cred->ako_permitted[1] =3D current->cred->cap_permitted.cap[1]=
;
+        ako_cred->ako_effective[0] =3D current->cred->cap_effective.cap[0]=
;
+        ako_cred->ako_effective[1] =3D current->cred->cap_effective.cap[1]=
;
+        ako_cred->ako_bset[0] =3D current->cred->cap_bset.cap[0];
+        ako_cred->ako_bset[1] =3D current->cred->cap_bset.cap[1];
+
+        return;
+}
+
+/*copy from sys.c*/
+static int set_user(struct cred *new)
+{
+	struct user_struct *new_user;
+
+	new_user =3D alloc_uid(new->uid);
+	if (!new_user)
+		return -EAGAIN;
+
+	/*
+	 * We don't fail in case of NPROC limit excess here because too many
+	 * poorly written programs don't check set*uid() return code, assuming
+	 * it never fails if called by root.  We may still enforce NPROC limit
+	 * for programs doing set*uid()+execve() by harmlessly deferring the
+	 * failure to the execve() stage.
+	 */
+	if (atomic_read(&new_user->processes) >=3D rlimit(RLIMIT_NPROC) &&
+			new_user !=3D INIT_USER)
+		current->flags |=3D PF_NPROC_EXCEEDED;
+	else
+		current->flags &=3D ~PF_NPROC_EXCEEDED;
+
+	free_uid(new->user);
+	new->user =3D new_user;
+	return 0;
+}
+
+
+static int AKO_restore_uids(struct ako_struct * ako_cred)
+{
+        struct cred *new;
+        struct user_namespace *ns =3D current_user_ns();
+        kuid_t uid;
+        kuid_t suid;
+        kuid_t euid;
+        kuid_t fsuid;
+	kernel_cap_t effective, permitted;
+       =20
+	new =3D prepare_creds();
+        if (!new)
+                return -ENOMEM;
+
+        uid =3D make_kuid(ns, ako_cred->ako_uid);
+        if (!uid_valid(uid))
+                return -EINVAL;
+        suid =3D make_kuid(ns, ako_cred->ako_suid);
+        if (!uid_valid(suid))
+                return -EINVAL;
+        euid =3D make_kuid(ns, ako_cred->ako_euid);
+        if (!uid_valid(euid))
+                return -EINVAL;
+        fsuid =3D make_kuid(ns, ako_cred->ako_fsuid);
+        if (!uid_valid(fsuid))
+                return -EINVAL;
+        new->uid =3D uid;
+        new->suid =3D suid;
+        new->euid =3D euid;
+        new->fsuid =3D fsuid;
+
+	/*clear capabilities*/
+	effective.cap[0] =3D 0;
+	effective.cap[1] =3D 0;
+	permitted.cap[0] =3D 0;
+	permitted.cap[1] =3D 0;
+	new->cap_effective  =3D effective;
+	new->cap_permitted  =3D permitted;
+
+	set_user(new);
+        commit_creds(new);
+        return 0;
+}
+
+static int AKO_restore_gids(struct ako_struct * ako_cred)
+{
+        struct cred *new;
+        struct user_namespace *ns =3D current_user_ns();
+        kgid_t gid;
+        kgid_t sgid;
+        kgid_t egid;
+        kgid_t fsgid;
+	kernel_cap_t effective, permitted;
+
+        new =3D prepare_creds();
+        if (!new)
+                return -ENOMEM;
+
+        gid =3D make_kgid(ns, ako_cred->ako_gid);
+        if (!gid_valid(gid))
+                return -EINVAL;
+        sgid =3D make_kgid(ns, ako_cred->ako_sgid);
+        if (!gid_valid(sgid))
+                return -EINVAL;
+        egid =3D make_kgid(ns, ako_cred->ako_egid);
+        if (!gid_valid(egid))
+                return -EINVAL;
+        fsgid =3D make_kgid(ns, ako_cred->ako_fsgid);
+        if (!gid_valid(fsgid))
+                return -EINVAL;
+        new->gid =3D gid;
+        new->sgid =3D sgid;
+        new->egid =3D egid;
+        new->fsgid =3D fsgid;
+
+        /*clear capabilities*/
+	effective.cap[0] =3D 0;
+	effective.cap[1] =3D 0;
+	permitted.cap[0] =3D 0;
+	permitted.cap[1] =3D 0;
+	new->cap_effective  =3D effective;
+	new->cap_permitted  =3D permitted;
+
+        commit_creds(new);
+
+        return 0;
+}
+static int AKO_restore_caps(struct ako_struct * ako_cred)
+{
+        struct cred *new;
+        kernel_cap_t inheritable, permitted, effective, bset;
+        unsigned i;
+        new =3D prepare_creds();
+        if (!new)
+                return -ENOMEM;
+
+        for (i =3D 0; i<2; i++) {
+                inheritable.cap[i] =3D ako_cred->ako_inheritable[i];
+                permitted.cap[i] =3D ako_cred->ako_permitted[i];
+                effective.cap[i] =3D ako_cred->ako_effective[i];
+                bset.cap[i] =3D ako_cred->ako_bset[i];
+        }
+
+        new->cap_effective   =3D effective;
+        new->cap_inheritable =3D inheritable;
+        new->cap_permitted   =3D permitted;
+        new->cap_bset   =3D bset;
+
+        commit_creds(new);
+
+        return 0;
+}
+
+inline int AKO_syscall_checked(int sysnum)
+{
+	 /*Since following system calls change credential information,
+          AKO does not detect attacks for them*/
+
+        if((sysnum =3D=3D __NR_execve)   || (sysnum =3D=3D __NR_setuid)   =
 || (sysnum =3D=3D __NR_setgid)    || (sysnum =3D=3D __NR_setreuid) ||
+           (sysnum =3D=3D __NR_setregid) || (sysnum =3D=3D __NR_setresuid)=
 || (sysnum =3D=3D __NR_setresgid) || (sysnum =3D=3D __NR_setfsuid) ||
+           (sysnum =3D=3D __NR_setfsgid) || (sysnum =3D=3D __NR_capset)   =
 || (sysnum =3D=3D __NR_prctl) || (sysnum =3D=3D __NR_unshare)  ){
+                return 0;
+        }
+	return 1;
+
+}
+
+void AKO_check_creds(struct ako_struct * ako_cred)
+{
+        /*Called at the exit of system call */
+        /*Compare credntial information before the systemcall
+          if changed, the information is restored and logged*/
+	int uid_modified =3D 0;
+	int gid_modified =3D 0;
+ 	int cap_modified =3D 0;=09
+
+        /*check uids*/
+        if(ako_cred->ako_uid !=3D current->cred->uid.val || ako_cred->ako_=
euid !=3D current->cred->euid.val || ako_cred->ako_fsuid !=3D current->cred=
->fsuid.val ||
+           ako_cred->ako_suid !=3D current->cred->suid.val){
+		audit_AKO_uid(ako_cred);
+		uid_modified =3D 1;
+        }
+
+	/*Check gids*/
+        if(ako_cred->ako_gid !=3D current->cred->gid.val || ako_cred->ako_=
egid !=3D current->cred->egid.val || ako_cred->ako_fsgid !=3D current->cred=
->fsgid.val ||
+           ako_cred->ako_sgid !=3D current->cred->sgid.val){
+		audit_AKO_gid(ako_cred);
+		gid_modified =3D 1;	=09
+        }
+	/*Check capabilities*/
+        if(ako_cred->ako_inheritable[0] !=3D current->cred->cap_inheritabl=
e.cap[0] || ako_cred->ako_inheritable[1] !=3D current->cred->cap_inheritabl=
e.cap[1] ||
+           ako_cred->ako_permitted[0]   !=3D current->cred->cap_permitted.=
cap[0]   || ako_cred->ako_permitted[1]   !=3D current->cred->cap_permitted.=
cap[1]   ||
+           ako_cred->ako_effective[0]   !=3D current->cred->cap_effective.=
cap[0]   || ako_cred->ako_effective[1]   !=3D current->cred->cap_effective.=
cap[1]   ||
+           ako_cred->ako_bset[0]        !=3D current->cred->cap_bset.cap[0=
]        || ako_cred->ako_bset[1]        !=3D current->cred->cap_bset.cap[1=
] ){
+		audit_AKO_cap(ako_cred);
+		cap_modified =3D 1;
+        }
+
+	/*restore creds if modified*/
+	if (uid_modified) {
+		/*Restore uids*/
+               if(!AKO_restore_uids(ako_cred))
+                        audit_AKO_restore(ako_cred,"uids");
+                else
+                        do_exit(SIGKILL);
+
+	}
+	if (gid_modified) {
+                /*Restore gids*/
+                if(!AKO_restore_gids(ako_cred))
+                        audit_AKO_restore(ako_cred,"gids");
+                else
+                        do_exit(SIGKILL);
+	}
+	if (cap_modified) {
+		/*restore capabilities*/
+		if(!AKO_restore_caps(ako_cred))
+			audit_AKO_restore(ako_cred,"capabilities");
+		else
+			do_exit(SIGKILL);
+	}
+
+        return;
+}
--- linux-4.4.0-62-83.orig/include/linux/ako.h	1970-01-01 09:00:00.00000000=
0 +0900
+++ linux-4.4.0/include/linux/ako.h	2017-07-04 22:33:45.188000000 +0900
@@ -0,0 +1,35 @@
+#ifndef __LINUX__AKO_H
+#define __LINUX__AKO_H
+/*
+ * Additional Kernel Observer (AKO)
+ * Copyright (c) 2017 Okayama-University
+ *     Yohei Akao, Yamauchi Laboratory, Okayama University
+ * Copyright (c) 2017 Hitachi,Ltd.
+ *	Yuichi Nakamura
+ */
+
+struct ako_struct{
+int ako_sysnum;
+/*Credential information to be observed*/
+unsigned long ako_addr_limit;
+uid_t  ako_uid;
+uid_t  ako_euid;
+uid_t  ako_fsuid;
+uid_t  ako_suid;
+gid_t  ako_gid;
+gid_t  ako_egid;
+gid_t  ako_fsgid;
+gid_t  ako_sgid;
+__u32  ako_inheritable[2];
+__u32  ako_permitted[2];
+__u32  ako_effective[2];
+__u32  ako_bset[2];
+};
+extern void AKO_save_creds(struct ako_struct * ako_cred, int ako_sysnum);
+extern void AKO_check_creds(struct ako_struct * ako_cred);
+extern void AKO_save_addr_limit(struct ako_struct * ako_cred);
+extern int AKO_syscall_checked(int sysnum);
+extern void audit_AKO_rlimit(struct ako_struct * ako_cred, unsigned long c=
urrent_addr_limit);
+extern void audit_AKO_restore(struct ako_struct * ako_cred, const char * c=
red_type);
+
+#endif
--- linux-4.4.0-62-83.orig/kernel/Makefile	2017-06-18 14:33:57.240000000 +0=
900
+++ linux-4.4.0/kernel/Makefile	2017-07-04 22:29:00.004000000 +0900
@@ -13,6 +13,8 @@
=20
 obj-$(CONFIG_MULTIUSER) +=3D groups.o
=20
+obj-$(CONFIG_AKO) +=3D ako.o
+
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
 CFLAGS_REMOVE_cgroup-debug.o =3D $(CC_FLAGS_FTRACE)
--- linux-4.4.0-62-83.orig/arch/x86/kernel/Makefile	2017-06-18 14:34:04.180=
000000 +0900
+++ linux-4.4.0/arch/x86/kernel/Makefile	2017-07-04 22:16:11.372000000 +090=
0
@@ -23,6 +23,7 @@
 CFLAGS_irq.o :=3D -I$(src)/../include/asm/trace
=20
 obj-y			:=3D process_$(BITS).o signal.o
+obj-$(CONFIG_AKO)	+=3D ako.o
 obj-$(CONFIG_COMPAT)	+=3D signal_compat.o
 obj-y			+=3D traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+=3D time.o ioport.o dumpstack.o nmi.o
--- linux-4.4.0-62-83.orig/init/Kconfig	2017-06-18 14:33:57.236000000 +0900
+++ linux-4.4.0/init/Kconfig	2017-07-04 22:14:43.080000000 +0900
@@ -333,6 +333,17 @@
 	depends on AUDITSYSCALL
 	select FSNOTIFY
=20
+config HAVE_ARCH_AKO
+        bool
+
+config AKO
+        bool "Enable Additional Kernel Observer (AKO)"=20
+        depends on AUDIT && HAVE_ARCH_AKO
+        help
+          AKO detects and prevents priviledge escalation attacks=20
+          that exploit vulnerabilities of kernel
+
+
 source "kernel/irq/Kconfig"
 source "kernel/time/Kconfig"
=20
--- linux-4.4.0-62-83.orig/arch/x86/Kconfig	2017-06-18 14:34:03.924000000 +=
0900
+++ linux-4.4.0/arch/x86/Kconfig	2017-07-06 12:27:26.692000000 +0900
@@ -76,6 +76,7 @@
 	select HAVE_ACPI_APEI_NMI		if ACPI
 	select HAVE_ALIGNED_STRUCT_PAGE		if SLUB
 	select HAVE_AOUT			if X86_32
+	select HAVE_ARCH_AKO			if X86_64
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_HUGE_VMAP		if X86_64 || X86_PAE
 	select HAVE_ARCH_JUMP_LABEL
--- linux-4.4.0-62-83.orig/arch/x86/entry/entry_64.S	2017-06-18 14:34:04.00=
8000000 +0900
+++ linux-4.4.0/arch/x86/entry/entry_64.S	2017-07-01 23:07:43.824000000 +09=
00
@@ -182,9 +182,43 @@
 #endif
 	ja	1f				/* return -ENOSYS (already in pt_regs->ax) */
 	movq	%r10, %rcx
+/*
+ * Additional Kernel Observer (AKO)
+ * Copyright (c) 2017 Okayama-University
+ *     Yohei Akao, Yamauchi Laboratory, Okayama University
+ */
+	subq	$6144,%rsp /*Allocate area in stack to save credential information*/
+	ALLOC_PT_GPREGS_ON_STACK
+	SAVE_C_REGS
+	SAVE_EXTRA_REGS
+	leaq	15*8(%rsp), %rdi /* size of SAVE_C_REGS and size of SAVE_EXTRA_REGS =
is added to rsp, and start address of allocated area is saved in %rdi*/
+	movq	%rax, %rsi /* Syscall number(%rax) is saved in %rsi */
+	call AKO_before /*credential information is saved*/
+	RESTORE_EXTRA_REGS
+	RESTORE_C_REGS
+	REMOVE_PT_GPREGS_FROM_STACK
+	addq	$6144,%rsp /*Allocate area in stack to save credential information*/
+	/*end of AKO*/
 	call	*sys_call_table(, %rax, 8)
+/*
+ * Additional Kernel Observer (AKO)
+ * Copyright (c) 2017 Okayama-University
+ *     Yohei Akao, Yamauchi Laboratory, Okayama University
+ */
+	/*Start of AKO*/
+	subq	$6144,%rsp
+	ALLOC_PT_GPREGS_ON_STACK
+	SAVE_C_REGS
+	SAVE_EXTRA_REGS
+	leaq	15*8(%rsp), %rdi
+	call AKO_after
+	RESTORE_EXTRA_REGS
+	RESTORE_C_REGS
+	REMOVE_PT_GPREGS_FROM_STACK
+	/*Free area to store credential infomation*/
+	addq	$6144,%rsp
+	/*End of AKO*/
 	movq	%rax, RAX(%rsp)
-1:
 /*
  * Syscall return path ending with SYSRET (fast path).
  * Has incompletely filled pt_regs.
