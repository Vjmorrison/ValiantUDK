class VG_WeaponAttachment extends UTAttachment_ShockRifle;

DefaultProperties
{
	// Weapon SkeletalMesh
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'WP_ShockRifle.Mesh.SK_WP_ShockRifle_3P'
	End Object

	DefaultImpactEffect=(ParticleTemplate=ParticleSystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Beam_Impact', Sound=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_AltFireImpactCue')
	ImpactEffects(0)=(MaterialType=Water, ParticleTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Beam_Impact_HIT', Sound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_FireCue')
	BulletWhip=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_WhipCue'

	MuzzleFlashSocket=MuzzleFlashSocket
//	MuzzleFlashPSCTemplate=WP_ShockRifle.Particles.P_ShockRifle_MF_Primary
	MuzzleFlashPSCTemplate=WP_ShockRifle.Particles.P_ShockRifle_3P_MF
	MuzzleFlashAltPSCTemplate=WP_ShockRifle.Particles.P_ShockRifle_3P_MF
	MuzzleFlashColor=(R=255,G=120,B=255,A=255)
	MuzzleFlashDuration=0.33;
	MuzzleFlashLightClass=class'UTGame.UTShockMuzzleFlashLight'
	BeamTemplate=particlesystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Beam'
	WeaponClass=class'UTWeap_ShockRifle'
	ImpactLightClass=class'UTShockImpactLight'
}
